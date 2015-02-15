
class Avatar

  def initialize(kata,name)
    raise 'Invalid Avatar(name)' if !Avatars.valid?(name)
    @kata,@name = kata,name
  end

  attr_reader :kata, :name

  def exists?
    dir.exists?
  end

  def start
    dir.make
    git.init(path, '--quiet')    
    git.config(path, user_name)
    git.config(path, user_email)
    
    save_manifest(kata.visible_files)
    git.add(path, manifest_filename)
    
    save_increments([ ])
    git.add(path, increments_filename)    
    
    sandbox.start
    tag = 0
    commit(tag)    
  end
  
  def path
    kata.path + name + '/'
  end

  def active?
    # o) Players sometimes start an extra avatar solely to read the
    #    instructions. I don't want these avatars appearing on the
    #    dashboard.
    # o) When forking a new kata you can enter as one animal
    #    to sanity check it is ok (but not press [test])
    exists? && lights.count > 0
  end

  def tags
    # See comment below.
    (0..increments.length).map{ |n| Tag.new(self,n) }
  end

  def lights
    # See comment below.
    increments.map { |inc| Light.new(self,inc) }
  end

  def visible_files
    # equivalent to tags[-1].visible_files but much easier
    # to test (faking files is easier than faking git)
    JSON.parse(dir.read(manifest_filename))
  end

  def test(delta, visible_files, now = time_now, time_limit = 15)
    delta[:changed].each do |filename|
      sandbox.write(filename, visible_files[filename])
    end
    delta[:new].each do |filename|
      sandbox.write(filename, visible_files[filename])
      git.add(sandbox.path, filename)
    end
    delta[:deleted].each do |filename|
      git.rm(sandbox.path, filename)
    end

    pre_test_filenames = visible_files.keys

    output = runner.run(sandbox, './cyber-dojo.sh', time_limit)
    sandbox.write('output', output) # so output appears in diff-view
    visible_files['output'] = output
    kata.language.after_test(sandbox.dir, visible_files)

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
    save_increments(rags)
    commit(rags.length)

    [rags,new_files,filenames_to_delete]
  end

  def sandbox
    Sandbox.new(self)
  end

private

  include ExternalDiskDir
  include ExternalGit
  include ExternalRunner
  include TimeNow

  def commit(tag)
    git.commit(path, "-a -m '#{tag}' --quiet")
    git.gc(path, '--auto --quiet')
    git.tag(path, "-m '#{tag}' #{tag} HEAD")
  end

  def save_manifest(visible_files)
    dir.write(manifest_filename, visible_files)
  end

  def save_increments(increments)
    dir.write(increments_filename, increments)    
  end
  
  def increments
    @increments ||= JSON.parse(dir.read(increments_filename))
  end

  def manifest_filename
    'manifest.json'
  end
    
  def increments_filename
    'increments.json'
  end
  
  def user_name
    "user.name #{quoted(name + '_' + kata.id)}"
  end

  def user_email 
    "user.email #{quoted(name)}@cyber-dojo.org"
  end

  def quoted(s)
    '"' + s + '"'
  end

end

# When a new avatar enters a dojo, kata.start_avatar()
# will do a 'git commit' + 'git tag' for tag 0 (Zero).
# This initial tag is *not* recorded in the
# increments.json file which starts as [ ]
#
# All subsequent 'git commit' + 'git tag' commands
# correspond to a gui action and store an entry in
# the increments.json file.
# eg
# [
#   {
#     'colour' => 'red',
#     'time' => [2014, 2, 15, 8, 54, 6],
#     'number' => 1
#   },
# ]
#
# At the moment the only gui action that creates an
# increments.json file entry is a [test] event.
#
# However, I may create finer grained tags than
# just [test] events...
#    o) creating a new file
#    o) renaming a file
#    o) deleting a file
#    o) editing a file (and opening a different file)
#
# If this happens the difference between a Tag.new
# and a Light.new will be more pronounced and I will
# need something like this (where non test events
# will have a new non red/amber/green colour) ...
#
# def lights
#   rag = ['red','amber','green']
#   increments.select{ |inc|
#     rag.include?(inc.colour)
#   }.map { |inc|
#     Light.new(self,inc)
#   }
# end
#
# ------------------------------------------------------
# Invariants
#
# If the latest tag is N then increments.length == N
#
# The inclusive upper bound for n in avatar.tags[n] is
# always the current length of increments.json (even if
# that is zero) which is also the latest tag number.
#
# The inclusive lower bound for n in avatar.tags[n] is
# zero. When an animal does a diff of [1] what is run is
#   avatar.tags[was_tag=0].diff(now_tag=1)
#
