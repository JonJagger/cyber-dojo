
class Kata

  def initialize(filesets)
    @filesets = filesets
    @manifest = {}
    @manifest[:visible_files] = {}
    @manifest[:hidden_filenames] = []
    @manifest[:hidden_pathnames] = []    
    filesets.each do |name,value|
      FileSet.read(@manifest, name + '/' + value)
    end
  end
  
  def filesets
    @filesets
  end

  def manifest
    @manifest
  end

  def language
    @filesets['language']
  end
  
  def name
    @filesets['kata']
  end
  
  #TODO: this should be at Dojo level, not in a kata or fileset
  def max_run_tests_duration
    (manifest[:max_run_tests_duration] || 10).to_i      
  end

  def tab
    " " * (manifest[:tab_size] || 4)
  end

  def unit_test_framework
    manifest[:unit_test_framework]
  end
  
  def visible_files
    manifest[:visible_files]
  end

  def hidden_pathnames
    manifest[:hidden_pathnames]
  end

  def hidden_filenames
    manifest[:hidden_filenames]
  end

end


