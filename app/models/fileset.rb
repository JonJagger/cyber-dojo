
class FileSet

  # In a multi-kata dojo, if you list the kata/language
  # filesets alphabetically there is a strong likelihood 
  # each station will simply pick the first entry. That 
  # happened at the 2010 NDC conference for example. Listing 
  # them in a random order increases the chances stations
  # will make different selections, which hopefully will
  # increase the potential for collaboration - the game's
  # prime directive.
  
  def self.names
  	Dir.entries(Root_folder).select { |name| name != '.' and name != '..' }
  end

  def initialize(name)
  	@name = name
  end
  
  def choices
    Dir.entries(Root_folder + '/' + @name).select do |name| 
      name != '.' and name != '..'
    end.sort_by {rand}
  end
  
  def self.read(manifest, file_set_name)
  	# called from kata.rb read_manifest()
    path = Root_folder + '/' + file_set_name
    file_set = eval IO.read(path + '/' + 'manifest.rb')
    file_set.each do |key,value|
	    if key == :visible_filenames
        manifest[:visible].merge! read_visible(path, value)
      elsif key == :hidden_filenames
        manifest[:hidden_filenames] += value
        manifest[:hidden_pathnames] += read_hidden_pathnames(path, value)
      else
        manifest[key] = value
      end
    end    
  end

private

  Root_folder = RAILS_ROOT + '/' + 'filesets'

  def self.read_visible(file_set_folder, filenames)
    visible_files = {}
    filenames.each do |filename|
      visible_files[filename] = 
        { :content => IO.read(file_set_folder + '/' + filename),
          :caret_pos => 0 
        }
    end
    visible_files
  end

  def self.read_hidden_pathnames(file_set_folder, filenames)
    pathed = []
    filenames.each do |filename|
      pathed << file_set_folder + '/' + filename
    end
    pathed
  end

end


