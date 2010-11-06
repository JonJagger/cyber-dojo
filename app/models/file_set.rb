
class FileSet

  def self.names
  	folders_in(Root_folder)
  end

  def self.random(name)
    FileSet.new(name).choices.shuffle[0]
  end
  
  def initialize(name)
  	@name = name
  end

  def choices
    FileSet.folders_in(Root_folder + '/' + @name)
  end  
  
  def self.read(manifest, file_set_name)
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

  def self.folders_in(path)
    Dir.entries(path).select { |name| name != '.' and name != '..' }
  end    

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


