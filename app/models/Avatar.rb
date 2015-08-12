# See comments at end of file

class Avatar

  include ExternalParentChain

  def initialize(kata,name)
    raise 'Invalid Avatar(name)' if !Avatars.valid?(name)
    @parent,@name = kata,name
  end

  attr_reader :name

  def kata
    @parent
  end
  
  def exists?
    dir.exists?
  end

  def start
    dir.make
    git_setup
    write_manifest(kata.visible_files)
    git.add(path,manifest_filename)
    write_increments([ ])
    git.add(path,increments_filename)     
    sandbox.start
    git_commit(0)    
    runner.started(self)
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
    (tag0 + increments).map{ |h| Tag.new(self,h) }
  end

  def lights
    tags.select{ |tag| tag.light? }
  end

  def visible_files
    # Equivalent to tags[-1].visible_files but
    # faking files is easier than faking git.
    JSON.parse(read(manifest_filename))
  end

  def test(delta, files, now = time_now, time_limit = 15)
    sandbox.save_files(delta,files)
    runner.pre_test(self)
    output = sandbox.run_tests(files, time_limit)
    colour = kata.language.colour(output)
    rags = increments
    tag = rags.length + 1
    rag = { 'colour' => colour, 'time' => now, 'number' => tag }
    rags << rag
    write_increments(rags)
    write_manifest(files)    
    git_commit(tag)    
    runner.post_commit_tag(self)
    [rags,output]    
  end

  def diff(n,m)
    command = "--ignore-space-at-eol --find-copies-harder #{n} #{m} sandbox"
    diff_lines = git.diff(path,command)
    visible_files = tags[m].visible_files
    git_diff(diff_lines, visible_files)
  end

  def sandbox
    Sandbox.new(self)
  end

private

  include GitDiff
  include TimeNow

  def git_setup
    git.init(path, '--quiet')
    git.config(path, 'user.name ' + user_name)
    git.config(path, 'user.email ' + user_email)
    git.config(path, '--global push.default simple')
  end

  def git_commit(tag)
    git.commit(path, "-a -m '#{tag}' --quiet")
    git.gc(path, '--auto --quiet')
    git.tag(path, "-m '#{tag}' #{tag} HEAD")
  end

  def tag0
    @zeroth ||= [
      'event' => 'created',
      'time' => time_now(kata.created),
      'number' => 0
    ]
  end

  def write_manifest(files)
    write(manifest_filename, files)
  end

  def write_increments(increments)
    write(increments_filename, increments)    
  end
  
  def write(filename,content)
    dir.write(filename,content)
  end
  
  def read(filename)
    dir.read(filename)
  end
  
  def increments
    JSON.parse(read(increments_filename))
  end
  
  def manifest_filename
    'manifest.json'
  end
    
  def increments_filename
    # stores cache of key-info for each git commit tag
    # helps optimize the dashboard    
    'increments.json'
  end

  def user_name
    "#{quoted(name + '_' + kata.id)}"
  end

  def user_email 
    "#{quoted(name)}@cyber-dojo.org"
  end

  def quoted(s)
    '"' + s + '"'
  end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# An avatar's source files are held in its sandbox folder.
# The top level folder holds config info such as manifests
# and caches.
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# tags vs lights
#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When a new avatar enters a dojo, kata.start_avatar()
# will do a 'git commit' + 'git tag' for tag 0 (zero).
# This initial tag is *not* recorded in the
# increments.json file which starts as [ ]
# It probably should be but isn't for existing dojos
# and so for backwards compatibility it stays that way.
#
# All subsequent 'git commit' + 'git tag' commands
# correspond to a gui action and store an entry in the
# increments.json file.
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
#    o) opening a different file
#    o) editing a file 
#
# If this happens the difference between tags and lights
# will be more pronounced.
# ------------------------------------------------------
# Invariants
#
# If the latest tag is N then
#   o) increments.length == N
#   o) tags.length == N+1
#
# The inclusive upper bound for n in avatar.tags[n] is
# always the current length of increments.json (even if
# that is zero) which is also the latest tag number.
#
# The inclusive lower bound for n in avatar.tags[n] is
# zero. When an animal does a diff of [1] what is run is
#   avatar.diff(0,1)
# which is a diff between
#   avatar.tags[0] and avatar.tags[1]
#
# ------------------------------------------------------





