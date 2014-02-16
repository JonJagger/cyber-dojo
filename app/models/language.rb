require 'DiskFile'

class Language
  
  def self.exists?(root_dir, name)
    @file = Thread.current[:file] || DiskFile.new    
    @file.directory?(Language.new(root_dir,name).dir)
  end
  
  #---------------------------------
  
  def initialize(root_dir, name)
    @file = Thread.current[:file] || DiskFile.new
    @root_dir = root_dir
    @name = name
  end
     
  def name
    @name
  end

  def dir
    @root_dir + @file.separator + 'languages' + @file.separator + name
  end
    
  def visible_files
    Hash[visible_filenames.collect{|filename| [filename, @file.read(dir, filename)]}]
  end

  def support_filenames
    manifest['support_filenames'] || [ ]
  end

  def highlight_filenames
    manifest['highlight_filenames'] || [ ]
  end

  def unit_test_framework
    manifest['unit_test_framework']
  end
  
  def tab
    " " * tab_size
  end
  
  def tab_size
    manifest['tab_size'] || 4
  end
  
private

  def visible_filenames
    manifest['visible_filenames'] || [ ]
  end

  def manifest
    @manifest = JSON.parse(@file.read(dir, 'manifest.json'))
  end
  
end
