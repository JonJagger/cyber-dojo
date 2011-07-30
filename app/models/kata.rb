
class Kata

  def initialize(filesets_root, filesets)
    @filesets = filesets
    @manifest = {
      :visible_files => {},
      :hidden_filenames => [],
      :hidden_pathnames => []
    }
    filesets.each do |name,choice|
      FileSet.new(filesets_root, name.to_s).read_into(@manifest, choice)
    end
  end
  
  def filesets
    @filesets
  end

  def manifest
    @manifest
  end

  def language
    @filesets[:language]
  end
  
  def name
    @filesets[:kata]
  end

  def max_run_tests_duration
    manifest[:max_run_tests_duration] || 10
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


