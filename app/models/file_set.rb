
require 'Folders'

class FileSet

  include Folders
  
  def initialize(filesets_root, name)
    @filesets_root = filesets_root
    @name = name
  end

  def choices
    folders_in(path).sort
  end  
  
  def read_into(manifest, choice)
    fullpath = path + '/' + choice
    file_set = eval IO.read(fullpath + '/' + 'manifest.rb')
    file_set.each do |key,value|
      if key == :visible_filenames
        manifest[:visible_files].merge! FileSet::read_visible(fullpath, value)
      elsif key == :hidden_filenames
        manifest[:hidden_filenames] += value
        manifest[:hidden_pathnames] += FileSet::read_hidden_pathnames(fullpath, value)
      else
        manifest[key] = value
      end
    end
    manifest[:visible_files]['output'] = '' 
  end
  
private

  def path
    @filesets_root + '/' + @name
  end

  def self.read_visible(file_set_folder, filenames)
    visible_files = { }
    filenames.each do |filename|
      visible_files[filename] = IO.read(file_set_folder + '/' + filename) 
    end
    visible_files
  end

  def self.read_hidden_pathnames(file_set_folder, filenames)
    pathed = [ ]
    filenames.each do |filename|
      pathed << file_set_folder + '/' + filename
    end
    pathed
  end

end


