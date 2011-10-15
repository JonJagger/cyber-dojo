
#require 'Folders'

class StartingFileSet # Rename as simply Manifest? Single folder only.

  #include Folders
  
  def initialize(folder_root, language, kata)
    fullpath = folder_root + '/' + language + '/' + kata
    manifest = eval IO.read(fullpath + '/' + 'manifest.rb')
    visible_files = {}
    manifest[:visible_filenames].each do |filename| 
      visible_files[filename] = IO.read(fullpath + '/' + filename)
    end

    @manifest = {
      :visible_files => visible_files
    }
  end

  def visible_files
    @manifest[:visible_files]
  end
  
private

end


