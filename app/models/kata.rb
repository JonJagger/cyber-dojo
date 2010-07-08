
class Kata

  def initialize(language_name, kata_name)
    @language = language_name
    @name = kata_name
    @manifest = read_manifest(language_name, kata_name)
  end

  def language
    @language
  end

  def name 
    @name.to_s
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

  def read_manifest(language_name, kata_name)
    manifest = {}
    manifest[:visible] = {}
    manifest[:hidden_filenames] = []
    manifest[:hidden_pathnames] = []
    FileSets.read(manifest, 'languages/' + language_name)
    FileSets.read(manifest, 'katas/' + kata_name)
    manifest
  end

end


