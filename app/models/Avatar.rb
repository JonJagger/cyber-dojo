
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
    git_init('--quiet')    
    git_config(user_name)
    git_config(user_email)
    
    save_manifest(kata.visible_files)
    git_add(manifest_filename)
    
    save_increments([ ])
    git_add(increments_filename)    
    
    sandbox.start
    commit(0)    
  end
  
  def path
    kata.path + name + '/'
  end

  def active?
    # See comment below.
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
    # See comment below.
    JSON.parse(read(manifest_filename))
  end

  def test(delta, visible_files, now = time_now, time_limit = 15)
    
    pre_test_filenames = visible_files.keys
    
    sandbox.pre_test(delta, visible_files)    
    output = runner.run(sandbox, './cyber-dojo.sh', time_limit)
    new_files,filenames_to_delete = sandbox.post_test(output, visible_files, pre_test_filenames)
    
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
    git_commit("-a -m '#{tag}' --quiet")
    git_gc('--auto --quiet')
    git_tag("-m '#{tag}' #{tag} HEAD")
  end

  def save_manifest(visible_files)
    write(manifest_filename, visible_files)
  end

  def save_increments(increments)
    write(increments_filename, increments)    
  end
  
  def write(filename,content)
    dir.write(filename,content)
  end
  
  def read(filename)
    dir.read(filename)
  end
  
  def increments
    @increments ||= JSON.parse(read(increments_filename))
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


#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# visible_files
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# equivalent to tags[-1].visible_files but much easier
# to test (faking files is easier than faking git)
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# active?
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# o) Players sometimes start an extra avatar solely to read the
#    instructions. I don't want these avatars appearing on the
#    dashboard.
# o) When forking a new kata you can enter as one animal
#    to sanity check it is ok (but not press [test])
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tags
# lights
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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
