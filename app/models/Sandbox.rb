
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
  
  def save_files(delta, files)
    delta[:deleted].each { |filename| git.rm(path,filename) }
    delta[:new    ].each { |filename| git_add(filename, filter(filename, files[filename])) }
    delta[:changed].each { |filename|   write(filename, filter(filename, files[filename])) }
  end

  def run_tests(files, time_limit)
    output = runner.run(self, './cyber-dojo.sh', time_limit)
    write('output', output) # so output is committed
    files['output'] = output    
    output
  end
  
private

  def filter(filename, content)
    avatar.kata.language.filter(filename,content)
  end

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
