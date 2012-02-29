
class LanguageFileSet
  
  def initialize(language_dir)
    @language_dir = language_dir
  end
     
  def visible_files
    seen = { }
    manifest[:visible_filenames].each do |filename|
      seen[filename] = IO.read("#{@language_dir}/#{filename}")
    end
    seen
  end
        
  def hidden_filenames
    manifest[:hidden_filenames] || [ ]
  end
  
private

  #unit_test_framework
  #tab_size
  
  def manifest
    @manifest ||= eval IO.read(@language_dir + '/manifest.rb')
  end
  
end
