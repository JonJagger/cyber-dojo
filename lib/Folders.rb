module Folders
  
  def self.in(path)
    Dir.entries(path).select { |name| name != '.' and name != '..' }
  end
  
end