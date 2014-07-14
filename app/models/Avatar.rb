root = '../..'
require_relative root + '/app/lib/Cleaner'
require_relative root + '/lib/TimeNow'

class Avatar

  def initialize(kata,name,externals)
    raise 'Invalid Avatar(name)' if !Avatars.valid?(name)
    @kata,@name,@externals = kata,name,externals
  end

  attr_reader :kata, :name

  def path
    kata.path + name + '/'
  end

  def dir
    disk[path]
  end

  def exists?
    dir.exists?
  end

  def active?
    # o) Players commonly start two avatars on the same computer and use
    #    one solely to read the instructions. I don't want these avatars
    #    appearing on the dashboard.
    # o) When an avatar enters a cyber-dojo the tests are automatically
    #    run. This means an avatar gets one traffic-light for free.
    # o) When forking a new kata it is common to enter as one animal
    #    to sanity check it is ok (but not press [test])
    exists? && lights.count > 1
  end

  def sandbox
    Sandbox.new(self,disk)
  end

  #- - - - - - - - - - - - - - -

  def tags
    # one tag for initial start_avatar
    # + one tag for each light. See comment below.
    (0..increments.length).map{ |n| Tag.new(self,n,git) }
  end

  def lights
    increments.map { |inc| Light.new(self,inc) }
  end

  #- - - - - - - - - - - - - - -

  def test(delta, visible_files, now = time_now, time_limit = 15)
    delta[:changed].each do |filename|
      sandbox.dir.write(filename, visible_files[filename])
    end
    delta[:new].each do |filename|
      sandbox.dir.write(filename, visible_files[filename])
      git.add(sandbox.path, filename)
    end
    delta[:deleted].each do |filename|
      git.rm(sandbox.path, filename)
    end

    pre_test_filenames = visible_files.keys

    output = clean(runner.run(sandbox, './cyber-dojo.sh', time_limit))
    sandbox.write('output', output) # so output appears in diff-view
    visible_files['output'] = output
    kata.language.after_test(sandbox, visible_files)

    new_files = visible_files.select { |filename|
      !pre_test_filenames.include?(filename)
    }
    new_files.keys.each { |filename|
      git.add(sandbox.path, filename)
    }

    filenames_to_delete = pre_test_filenames.select { |filename|
      !visible_files.keys.include?(filename)
    }

    save_manifest(visible_files)

    rags = increments
    rag = {
      'colour' => kata.language.colour(output),
      'time'   => now,
      'number' => rags.length + 1
    }
    rags << rag
    dir.write('increments.json', rags)
    commit(rags.length)

    [rags,new_files,filenames_to_delete]
  end

  def save_manifest(visible_files)
    dir.write('manifest.json', visible_files)
  end

  def commit(tag)
    git.commit(path, "-a -m '#{tag}' --quiet")
    git.tag(path, "-m '#{tag}' #{tag} HEAD")
  end

private

  include Cleaner
  include TimeNow

  def disk
    @externals[:disk]
  end

  def git
    @externals[:git]
  end

  def runner
    @externals[:runner]
  end

  def increments
    @increments ||= JSON.parse(clean(dir.read('increments.json')))
  end

end


# After an avatar starts (but before the first test is
# auto-run) a git.tag=0 occurs for the avatar
# and increments.json is created as [ ]
# So when there is 1 tag there are 0 lights
#
# After the first [test] is run a git.tag=1 is run
# and the increments.json file contains a single light,
# eg
# [
#   {
#     'colour' => 'red',
#     'time' => [2014, 2, 15, 8, 54, 6],
#     'number' => 1
#   },
# ]
# So when there are 2 tags there is 1 light
#
# Viz the number of git tags is always one more than
# the number of entries in increments.json
# This is because each entry in increments.json
# represents an activity causing the creation of a new
# tag from-the-current-tag.
# Thus the zero'th starting tag has no light because
# it is the base tag on which all lights are grown.
#
# Thus the inclusive upper bound for n in avatar.tags[n]
# is always the current length of increments.json
# (even if that is zero) which is also the latest tag number.