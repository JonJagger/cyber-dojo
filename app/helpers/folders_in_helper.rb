module FoldersInHelper
  
  def folders_in(path)
    Dir.entries(path).select { |name| name != '.' and name != '..' }
  end    

end