
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

  def self.complete(root_dir, id)
    if id != nil
      id.upcase!
      # if are at least 4 characters of the id are provided
      # provided attempt to do id-completion
      if id.length >= 4
        dirs = Dir[root_dir + '/katas/' + id[0..1] + '/' + id[2..-1] + '*']
        if dirs.length == 1
          dir = dirs[0]
          id = dir[dir.length-12..-1].tr("//","")
        end
      end
    end
    id   
  end
  
end