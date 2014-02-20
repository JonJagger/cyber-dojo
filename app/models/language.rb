require 'DiskFile'

class Language
    
  def initialize(dojo, name)
    @file = Thread.current[:disk] || DiskFile.new
    @dojo = dojo
    @name = name
  end
     
  def exists?
    @file.exists?(dir)
  end
  
  def name
    @name
  end

  def dir
    @dojo.dir + @file.separator + 'languages' + @file.separator + name
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
