
#require 'Folders'

class StartingFileSet
  # Rename as simply Manifest?
  # Idea is that this is a single folder only version of file_set.
  # I'd like to be able to create a new named starting fileset from
  # the files associated with any traffic-light. This would allow
  # any player (or the same player) to continue where another player
  # finished off. This could also be done without creating a named
  # fileset. This also leads nicely into a session timing out
  # after 60 minutes.

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


