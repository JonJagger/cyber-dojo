
class Sandbox

  include ExternalParentChain
  
  def initialize(avatar)
    @parent = avatar
  end

  def avatar
    @parent
  end
  
  def path
    avatar.path + 'sandbox/'
  end

  def start
    avatar.visible_files.each { |filename,content| 
      git_add(filename,content) 
    }
    language.support_filenames.each { |filename|
      disk.symlink(language.path + filename, path + filename)
    }
  end
  
  def run_tests(delta, files, time_limit)
    delta[:changed].each { |filename| write(filename, files[filename]) }
    delta[:new].each     { |filename| git_add(filename, files[filename]) }
    delta[:deleted].each { |filename| git.rm(path,filename) }
    output = runner.run(self, './cyber-dojo.sh', time_limit)
    write('output', output) # so output is committed
    files['output'] = output    
    output
  end
  
private

  def git_add(filename, content)
    write(filename,content)
    git.add(path,filename)
  end
    
  def write(filename, content)
    dir.write(filename, content)
  end

  def language
    avatar.kata.language
  end

end
