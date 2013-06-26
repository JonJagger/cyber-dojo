require 'Files'

class Language
  
  def initialize(root_dir, name)
    @root_dir = root_dir
    @name = name
  end
     
  def name
    @name
  end

  def dir
    @root_dir + File::SEPARATOR + 'languages' + File::SEPARATOR + name
  end
    
  def visible_files
    seen = { }
    manifest[:visible_filenames].each do |filename|
      seen[filename] = Files::file_read(dir, filename)
    end
    seen
  end
        
  def hidden_filenames
    manifest[:hidden_filenames] || [ ]
  end
  
  def support_filenames
    manifest[:support_filenames] || [ ]
  end
  
  def unit_test_framework
    manifest[:unit_test_framework]      
  end
  
  def tab
    " " * tab_size
  end
  
  def tab_size
    manifest[:tab_size] || 4
  end
  
private

  def manifest
    @manifest ||= eval Files::file_read(dir, 'manifest.rb')
  end
  
end
