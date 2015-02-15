
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def start
    avatar.visible_files.each do |filename,content|
      write(filename, content)
      git_add(filename)
    end    
    avatar.kata.language.support_filenames.each do |filename|
      from = avatar.kata.language.path + filename
        to = path + filename
      disk.symlink(from, to)
    end    
  end
  
  def pre_test(delta, visible_files)
    delta[:changed].each do |filename|
      write(filename, visible_files[filename])
    end
    delta[:new].each do |filename|
      write(filename, visible_files[filename])
      git_add(filename)
    end
    delta[:deleted].each do |filename|
      git_rm(filename)
    end    
  end
  
  
  def post_test(output, visible_files, pre_test_filenames)
    write('output', output) # so output appears in diff-view
    visible_files['output'] = output
    
    avatar.kata.language.after_test(dir, visible_files)

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

  def path
    avatar.path + 'sandbox/'
  end

private

  include ExternalDiskDir
  include ExternalGit

end
