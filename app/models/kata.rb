
class Kata

  def initialize(filesets)
    @manifest = read_manifest(filesets)
    @filesets = filesets
  end
  
  def filesets
    @filesets
  end

  def max_run_tests_duration
  # default max_run_tests_duration = 10 seconds
    (@manifest[:max_run_tests_duration] || 10).to_i      
  end

  def tab
    # default tab_size = 4
    " " * (@manifest[:tab_size] || 4)
  end

  def unit_test_framework
    @manifest[:unit_test_framework]
  end
  
  def visible
    @manifest[:visible]
  end

  def hidden_pathnames
    @manifest[:hidden_pathnames]
  end

  def hidden_filenames
    @manifest[:hidden_filenames]
  end

private

  def read_manifest(filesets)
    manifest = {}
    manifest[:visible] = {}
    manifest[:hidden_filenames] = []
    manifest[:hidden_pathnames] = []
    
    filesets.each do |name,value|
      FileSet.read(manifest, name + '/' + value)
    end
    
    manifest
  end

end


