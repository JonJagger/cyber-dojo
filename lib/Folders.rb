
module Folders
  
  def self.in(path)
    Dir.entries(path).select { |name| name != '.' and name != '..' }
  end
  
  def self.make_folder(path)
    folder = File.dirname(path)
    # the -p option creates intermediate directories as required
    cmd = "mkdir -p #{folder}"
    system(cmd)          
  end

end