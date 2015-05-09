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
    git.add(path,manifest_filename)
    write_increments([ ])
    git.add(path,increments_filename)     
    sandbox.start
    git_commit(0)    
  end
  
  def path
    kata.path + name + '/'
  end

  def active?
    exists? && lights.count > 0
  end

  def tags
    (zeroth + increments).map{ |h| Tag.new(self,h) }
  end

  def lights
    tags.select{ |tag| tag.light? }
  end

  def visible_files
    JSON.parse(read(manifest_filename))
  end

  def test(delta, files, now = time_now, time_limit = 15)        
    new_files,filenames_to_delete = sandbox.run_tests(delta,files,time_limit)    
    colour = kata.language.colour(files['output'])
    rags = increments
    tag = rags.length + 1
    rag = { 'colour' => colour, 'time' => now, 'number' => tag }
    rags << rag
    write_increments(rags)
    write_manifest(files)
    git_commit(tag)
    [rags,new_files,filenames_to_delete]
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
  end

  def git_commit(tag)
    git.commit(path, "-a -m '#{tag}' --quiet")
    git.gc(path, '--auto --quiet')
    git.tag(path, "-m '#{tag}' #{tag} HEAD")
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
  
  def zeroth
    [
      'event' => 'created',
      'time' => time_now(kata.created),
      'number' => 0
    ]
  end

  def manifest_filename
    'manifest.json'
  end
    
  def increments_filename
    # stores cache of key-info for each git commit tag
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




