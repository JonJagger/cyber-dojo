
# See comments at end of file

class HostDiskHistory

  def initialize(dojo)
    @dojo = dojo
  end

  def parent
    @dojo
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Katas
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def create_kata(katas, manifest)
    kata = Kata.new(katas, manifest[:id])
    make_dir(kata)
    dir(kata).write_json(manifest_filename, manifest)
    kata
  end

  def katas_complete_id(katas, id)
    # If at least 6 characters of the id are provided attempt to complete
    # it into the full 10 character id. Doing completion with fewer characters
    # would likely result in a lot of disk activity and no unique outcome.
    if !id.nil? && id.length >= 6
      outer_dir = disk[path(katas) + outer(id)]
      if outer_dir.exists?
        dirs = outer_dir.each_dir.select { |inner_dir| inner_dir.start_with?(inner(id)) }
        id = outer(id) + dirs[0] if dirs.length == 1
      end
    end
    id || ''
  end

  def katas_each(katas)
    disk[path(katas)].each_dir do |outer_dir|
      disk[path(katas) + outer_dir].each_dir do |inner_dir|
        yield outer_dir + inner_dir
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Kata
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_exists?(kata)
    dir(kata).exists?
  end

  def kata_manifest(kata)
    dir(kata).read_json(manifest_filename)
  end

  def kata_started_avatars(kata)
    lines = output_of(shell.cd_exec(path(kata), 'ls -F | grep / | tr -d /'))
    lines.split("\n") & Avatars.names
  end

  def kata_start_avatar(kata, avatar_names = Avatars.names.shuffle)
    avatar_name = avatar_names.detect do |name|
      _, exit_status = shell.cd_exec(path(kata), "mkdir #{name} #{stderr_2_stdout}")
      exit_status == shell.success
    end

    return nil if avatar_name.nil? # full!

    avatar = Avatar.new(kata, avatar_name)

    user_name = avatar.name + '_' + kata.id
    user_email = avatar.name + '@cyber-dojo.org'
    git.setup(path(avatar), user_name, user_email)

    write_avatar_manifest(avatar, kata.visible_files)
    git.add(path(avatar), manifest_filename)

    write_avatar_increments(avatar, [])
    git.add(path(avatar), increments_filename)

    sandbox = Sandbox.new(avatar)
    make_dir(sandbox)
    avatar.visible_files.each do |filename, content|
      write(sandbox, filename, content)
      git.add(path(sandbox), filename)
    end

    git.commit(path(avatar), tag=0)

    avatar_name
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Avatar
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def avatar_exists?(avatar)
    dir(avatar).exists?
  end

  def avatar_increments(avatar)
    dir(avatar).read_json(increments_filename)
  end

  def avatar_visible_files(avatar)
    dir(avatar).read_json(manifest_filename)
  end

  def avatar_run_tests(avatar, delta, files, now = time_now, max_seconds = 15)
    language = avatar.language
    raw = runner.run(avatar, delta, files, language.image_name, now, max_seconds)
    output = truncated(cleaned(raw))
    colour = avatar.language.colour(output)
    # save output
    rags = history.avatar_ran_tests(avatar, delta, files, now, output, colour)
    # TODO: return only last rag colour
    [rags, output]
  end

  def avatar_ran_tests(avatar, delta, files, now, output, colour)
    write(avatar.sandbox, 'output', output)
    files['output'] = output
    write_avatar_manifest(avatar, files)
    # Reds/Ambers/Greens
    rags = avatar_increments(avatar)
    tag = rags.length + 1
    rags << { 'colour' => colour, 'time' => now, 'number' => tag }
    write_avatar_increments(avatar, rags)
    git.commit(path(avatar), tag)
    rags
  end

  def avatar_git_diff(avatar, was_tag, now_tag)
    git.diff(path(avatar), was_tag, now_tag)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Tag
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def tag_visible_files(avatar, tag)
    JSON.parse(git.show(path(avatar), "#{tag}:#{manifest_filename}"))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Path
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def path(obj)
    case obj.class.name
    when 'Sandbox' then path(obj.parent) + 'sandbox' + '/'
    when 'Avatar'  then path(obj.parent) + obj.name + '/'
    when 'Kata'    then path(obj.parent) + outer(obj.id) + '/' + inner(obj.id) + '/'
    when 'Katas'   then obj.path
    end
  end

  def write(sandbox, filename, content)
    dir(sandbox).write(filename, content)
  end

  private

  include ExternalParentChainer
  include OutputCleaner
  include OutputTruncater
  include IdSplitter  # TODO: pull it into here? don't think anything else uses it now

  def make_dir(obj)
    dir(obj).make
  end

  def dir(obj)
    disk[path(obj)]
  end

  def write_avatar_manifest(avatar, files)
    dir(avatar).write_json(manifest_filename, files)
  end

  def write_avatar_increments(avatar, increments)
    dir(avatar).write_json(increments_filename, increments)
  end

  def increments_filename
    # Each avatar's increments stores a cache of colours and time-stamps
    # for all the avatar's [test]s. Helps optimize traffic-lights views.
    'increments.json'
  end

  def manifest_filename
    # Each kata's manifest stores the kata's meta information
    # such as the chosen language, tests, exercise.
    # Each avatar's manifest stores a cache of the avatar's
    # current visible files [filenames and contents].
    'manifest.json'
  end

  def output_of(args)
    args[0]
  end

  def stderr_2_stdout
    '2>&1'
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - -
# There are three main moving parts in cyber-dojo:
#
# 1. READ
#    the [languages,exercises,caches] folders which are
#    local to the cyber-dojo server and read-only.
#
# 2. EXECUTE
#    the runners which produce an output file from a set
#    of source files and a language's image_name. This
#    output is regex'd to get its Red/Amber/Green colour.
#
# 3. WRITE
#    the files+output from each [test] event are saved as
#    a tag in a git repo associated with the avatar. There
#    are also saves associated with creating each kata
#    and starting each each avatar.
#
# - - - - - - - - - - - - - - - - - - - - - - - -
# This class's methods holds all the reads/writes for 3.
# Currently it uses the cyber-dojo server's file-system [katas]
# folder using the same HostDisk object as 1 but this needs
# decoupling (see avatar_run_tests comments below).
#
# Viz, this class represents the API needed on its own
# dedicated web server.
# - - - - - - - - - - - - - - - - - - - - - - - -


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# kata_start_avatar(kata, avatar_names)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Starting an avatar needs to be atomic otherwise two
# laptops in a cyber-dojo could start as the same animal.
#
#   app/models/kata.rb    start_avatar()
#   app/models/avatars.rb started_avatars()
#
# On a non NFS POSIX file system I do this relying on
# mkdir being atomic.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# avatar_run_tests(avatar, delta, files, now, max_seconds)
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Currently works by saving the files to the file-system (in the avatar's
# sandbox) and *then* the runner makes use of these saved files
# (eg docker-runner's .sh file volume-mounts the sandbox).
#
# I plan to reverse this ordering and decouple the runners from the
# persistence strategy (the file-system + git). Namely...
#
# 1. Don't save the files to the file-system; let the runner decide what to
#    do. Maybe runner is hosted inside a web-server which receives the files,
#    saves them to a ram disk folder, which a docker image then volume-mounts.
#    Perhaps there are several such such servers for scalability. This also
#    suggests the the browser sending the files *directly* to such a web-server
#    rather than to the cyber-dojo server (which in turn sends them on to the
#    web-server).
#
# 2. Once the runner has finished, the output file is added to the files
#    sent from browser and persisted in one go (rather than two steps; one
#    for saving all the files except the output, another for saving just the
#    output).
#
# Note
# Step 2 can be executed as a background fire-and-forget task.
# The browser only needs the results of step 1.
# The rails view-code currently redraws *all* the traffic-lights
# but that needs refactoring.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



