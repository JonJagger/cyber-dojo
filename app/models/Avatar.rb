# comments at end of file

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
    git(:add,manifest_filename)
    write_increments([ ])
    git(:add,increments_filename)     
    sandbox.start
    git_commit(0)    
    #one_self.started(self)
  end
  
  def path
    kata.path + name + '/'
  end

  def active?
    exists? && lights.count > 0
  end

  def tags
    Tags.new(self)
  end

  def lights
    increments.map { |inc| Light.new(self,inc) }
  end

  def visible_files
    JSON.parse(read(manifest_filename))
  end

  def test(delta, files, now = time_now, time_limit = 15)        
    new_files,filenames_to_delete = sandbox.run_tests(delta,files,time_limit)    
    colour = kata.language.colour(files['output'])
    rags = increments
    rag = {
      'colour' => colour,
      'time'   => now,
      'number' => rags.length + 1
    }
    rags << rag
    write_increments(rags)
    write_manifest(files)
    tag = rags.length
    git_commit(tag)
    #one_self.tested(self,tag,colour)
    [rags,new_files,filenames_to_delete]
  end

  def diff(n,m)
    command = "--ignore-space-at-eol --find-copies-harder #{n} #{m} sandbox"
    diff_lines = git(:diff,command)
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
    git(:init, '--quiet')
    git(:config, 'user.name ' + user_name)
    git(:config, 'user.email ' + user_email)
  end

  def git_commit(tag)
    git(:commit, "-a -m '#{tag}' --quiet")
    git(:gc, '--auto --quiet')
    git(:tag, "-m '#{tag}' #{tag} HEAD")
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
    @increments ||= JSON.parse(read(increments_filename))
  end

  def manifest_filename
    'manifest.json'
  end
    
  def increments_filename
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




