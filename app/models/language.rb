require 'DiskFile'
require 'JSON'

class Language
  
  def initialize(root_dir, name)
    @root_dir = root_dir
    @name = name
    @file = Thread.current[:file] || DiskFile.new
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
    if @manifest
      return @manifest
    else
      object = eval @file.read(dir, 'manifest.rb')
      return @manifest = JSON.parse(JSON.unparse(object))
    end
  end
  
end
