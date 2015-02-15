
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def start
    avatar.visible_files.each do |filename,content|
      write(filename, content)
      git.add(path, filename)
    end    
    avatar.kata.language.support_filenames.each do |filename|
      from = avatar.kata.language.path + filename
        to = path + filename
      disk.symlink(from, to)
    end    
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
