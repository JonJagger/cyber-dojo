
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def path
    avatar.path + 'sandbox/'
  end

  def start
    avatar.visible_files.each { |filename,content|
      write(filename, content)
      git_add(filename)
    }
    language.support_filenames.each { |filename|
      disk.symlink(language.path + filename, path + filename)
    }
  end
  
  def run_tests(delta, visible_files, time_limit)
    visible_filenames = visible_files.keys    
    pre_test(delta, visible_files)    
    output = runner.run(self, './cyber-dojo.sh', time_limit)
    write('output', output) # so output is committed
    visible_files['output'] = output    
    post_test(visible_files, visible_filenames)    
  end
  
private

  include ExternalDiskDir
  include ExternalGit
  include ExternalRunner  

  def pre_test(delta, visible_files)
    delta[:changed].each { |filename|
      write(filename, visible_files[filename])
    }
    delta[:new].each { |filename|
      write(filename, visible_files[filename])
      git_add(filename)
    }
    delta[:deleted].each { |filename|
      git_rm(filename)
    }
  end
  
  def post_test(visible_files, pre_test_filenames)    
    language.after_test(dir, visible_files)
    new_files = visible_files.select { |filename|
      !pre_test_filenames.include?(filename)
    }
    new_files.keys.each { |filename|
      git_add(filename)
    }
    filenames_to_delete = pre_test_filenames.select { |filename|
      !visible_files.keys.include?(filename)
    }    
    [new_files,filenames_to_delete]
  end
  
  def write(filename, content)
    dir.write(filename, content)
  end

  def language
    avatar.kata.language
  end

end
