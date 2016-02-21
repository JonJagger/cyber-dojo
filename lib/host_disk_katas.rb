
# See comments at end of file

class HostDiskKatas
  include Enumerable

  def initialize(dojo)
    @parent = dojo
    @path = slashed(dojo.env('katas', 'root'))
  end

  attr_reader :path, :parent

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Katas
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def create_kata(language, exercise, id = unique_id, now = time_now)
    manifest = create_kata_manifest(language, exercise, id, now)
    create_kata_from_manifest(manifest)
  end

  def create_kata_from_manifest(manifest)
    kata = Kata.new(self, manifest[:id])
    dir(kata).make
    dir(kata).write_json(manifest_filename, manifest)
    kata
  end

  def completed(id)
    # Used only in enter_controller/check
    # If at least 6 characters of the id are provided attempt to complete
    # it into the full 10 character id. Doing completion with fewer characters
    # would likely result in a lot of disk activity and no unique outcome.
    # Also, if completion was attempted for a very short id (say 3 characters)
    # it would provide a way for anyone to find the full id of a cyber-dojo
    # and potentially interfere with a live session.
    if !id.nil? && id.length >= 6
      # outer-dir has 2-characters
      outer_dir = disk[path + outer(id)]
      if outer_dir.exists?
        # inner-dir has 8-characters
        dirs = outer_dir.each_dir.select { |inner_dir| inner_dir.start_with?(inner(id)) }
        id = outer(id) + dirs[0] if dirs.length == 1
      end
    end
    id || ''
  end

  def each
    return enum_for(:each) unless block_given?
    disk[path].each_dir do |outer_dir|
      disk[path + outer_dir].each_dir do |inner_dir|
        yield  Kata.new(self, outer_dir + inner_dir)
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Kata
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def [](id)
    return nil unless valid?(id)
    kata = Kata.new(self, id)
    exists?(kata) ? kata : nil
  end

  def kata_manifest(kata)
    dir(kata).read_json(manifest_filename)
  end

  def kata_started_avatars(kata)
    lines, _ = shell.cd_exec(path_of(kata), 'ls -F | grep / | tr -d /')
    lines.split("\n") & Avatars.names
  end

  def kata_start_avatar(kata, avatar_names = Avatars.names.shuffle)
    # Needs to be atomic otherwise two laptops in a cyber-dojo
    # could start as the same animal. This relies on mkdir being
    # atomic on a non NFS POSIX file system.
    # Don't do the & with operands swapped - you lose randomness
    valid_names = avatar_names & Avatars.names
    name = valid_names.detect do |valid_name|
      _, exit_status = shell.cd_exec(path_of(kata), "mkdir #{valid_name} > /dev/null #{stderr_2_stdout}")
      exit_status == shell.success
    end

    return nil if name.nil? # full!

    avatar = Avatar.new(kata, name)
    # it's dir has already been created in the mkdir above

    user_name = name + '_' + kata.id
    user_email = name + '@cyber-dojo.org'
    git.setup(path_of(avatar), user_name, user_email)

    write_avatar_manifest(avatar, kata.visible_files)
    git.add(path_of(avatar), manifest_filename)

    write_avatar_increments(avatar, [])
    git.add(path_of(avatar), increments_filename)

    sandbox = Sandbox.new(avatar)
    dir(sandbox).make
    avatar.visible_files.each do |filename, content|
      dir(sandbox).write(filename, content)
      git.add(path_of(sandbox), filename)
    end

    git.commit(path_of(avatar), tag=0)

    avatar
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Avatar
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def avatar_exists?(avatar)
    exists?(avatar)
  end

  def avatar_increments(avatar)
    # implicitly for current tag
    dir(avatar).read_json(increments_filename)
  end

  def avatar_visible_files(avatar)
    # implicitly for current tag
    dir(avatar).read_json(manifest_filename)
  end

  def avatar_ran_tests(avatar, delta, files, now, output, colour)
    dir(avatar.sandbox).write('output', output)
    files['output'] = output
    write_avatar_manifest(avatar, files)
    # update the increments Red/Amber/Green
    rags = avatar_increments(avatar)
    tag = rags.length + 1
    rags << { 'colour' => colour, 'time' => now, 'number' => tag }
    write_avatar_increments(avatar, rags)
    # git-commit the manifest, increments, and visible-files
    git.commit(path_of(avatar), tag)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Sandbox
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def sandbox_save(sandbox, delta, files)
    # Unchanged files are *not* re-saved.
    # lib/docker_katas_runner.rb relies on this.
    delta[:deleted].each do |filename|
      git.rm(path_of(sandbox), filename)
    end
    delta[:new].each do |filename|
      write(sandbox, filename, files[filename])
      git.add(path_of(sandbox), filename)
    end
    delta[:changed].each do |filename|
      write(sandbox, filename, files[filename])
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Tag
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def tag_visible_files(avatar, tag)
    # retrieve all the files in one go
    JSON.parse(git.show(path_of(avatar), "#{tag}:#{manifest_filename}"))
  end

  def tag_git_diff(avatar, was_tag, now_tag)
    git.diff(path_of(avatar), was_tag, now_tag)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -
  # Path
  # - - - - - - - - - - - - - - - - - - - - - - - -

  def dir(obj)
    disk[path_of(obj)]
  end

  def path_of(obj)
    case obj.class.name
    when 'Sandbox' then path_of(obj.parent) + 'sandbox' + '/'
    when 'Avatar'  then path_of(obj.parent) + obj.name + '/'
    when 'Kata'    then path_of(obj.parent) + outer(obj.id) + '/' + inner(obj.id) + '/'
    when self.class.name then path
    end
  end

  private

  include CreateKataManifest
  include ExternalParentChainer
  include IdSplitter
  include Slashed
  include StderrRedirect
  include TimeNow
  include UniqueId

  def exists?(obj)
    dir(obj).exists?
  end

  def write(sandbox, filename, content)
    dir(sandbox).write(filename, content)
  end

  def valid?(id)
    id.class.name == 'String' &&
      id.length == 10 &&
        id.chars.all? { |char| hex?(char) }
  end

  def hex?(char)
    '0123456789ABCDEF'.include?(char)
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
#    a tag in a git repo associated with the kata+avatar.
#    There are also writes associated with creating each
#    kata and starting each avatar.
#
# - - - - - - - - - - - - - - - - - - - - - - - -
# This class's methods holds all the reads/writes for 3.
# It uses the cyber-dojo server's file-system [katas] folder.
# This is *an* implementation of katas.
#
# There are two good reasons for using this implementation.
#
# 1. Suppose your cyber-dojo.sh files do an incremental make.
#    In this case, the date-time stamp of the source files
#    is important and you want untouched files to retain
#    their old date-time stamp. This means you need to save
#    only the changed files from each test event and you
#    need the unchanged files to still be where you left
#    them last time.
#
# 2. Creating the download page's tar file which includes all
#    the git repos of all the animals. This is obviously quite
#    trivial if the animals git repos have been updated every
#    test event.
# - - - - - - - - - - - - - - - - - - - - - - - -
# An alternative implementation could save the manifest containing
# the visible files for each test to a database. Then, to get a
# git diff it could
#    o) create a temporary git repository
#    o) save the files from was_tag to it
#    o) git tag and git commit
#    o) save the files from now_tag to it
#    o) git tag and git commit
#    o) do a git diff
#    o) delete the temporary git repository
# There is probably a library to do this in ram bypassing
# the need for a file-system completely.
# This would make creation of the tar file for
# a whole cyber-dojo potentially very slow.
# - - - - - - - - - - - - - - - - - - - - - - - -
