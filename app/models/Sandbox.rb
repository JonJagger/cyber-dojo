
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
    delta[:deleted].each do |filename|
      git.rm(path,filename)
    end

    delta[:new].each do |filename|
      content = filter(filename, files[filename])
      git_add(filename, content)
    end

    delta[:changed].each do |filename|
      content = filter(filename, files[filename])
      write(filename, content)
    end
  end

  def run_tests(files, time_limit)
    output = runner.run(self, './cyber-dojo.sh', time_limit)
    write('output', output) # so output is committed
    files['output'] = output    
    output
  end
  
private

  def filter(filename, content)
    # Cater for app/assets/javascripts/jquery-tabby.js plugin
    # See app/lib/MakefileFilter.rb 
    content = MakefileFilter.filter(filename, content)
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
