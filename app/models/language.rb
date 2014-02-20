
require 'Disk'

class Language
    
  def initialize(dojo, name)
    @disk = Thread.current[:disk] || Disk.new
    @dojo = dojo
    @name = name
  end
     
  def exists?
    @disk.exists?(dir)
  end
  
  def name
    @name
  end

  def dir
    @dojo.dir + file_separator + 'languages' + file_separator + name
  end
    
  def visible_files
    Hash[visible_filenames.collect{|filename| [filename, @disk.read(dir, filename)]}]
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

  def file_separator
    @disk.file_separator  
  end
  
  def visible_filenames
    manifest['visible_filenames'] || [ ]
  end

  def manifest
    @manifest = JSON.parse(@disk.read(dir, 'manifest.json'))
  end
  
end
