
# > ruby test/functional/initial_file_set_tests.rb

class InitialFileSet
  
  def initialize(params)
    @params = params
  end
  
  def copy_hidden_files_to(dir)
    # Use ln here and not cp - no need to create multiple
    # copies of files that are not going to be edited.
    hidden_filenames.each do |hidden_filename|
      system("ln '#{language_dir}/#{hidden_filename}' '#{dir}/#{hidden_filename}'")
    end
  end

  def visible_files
    seen = 
      { 'instructions' => IO.read(exercise_dir + '/instructions'),
        'output' => ''
      }
    manifest[:visible_filenames].each do |filename|
      seen[filename] = IO.read("#{language_dir}/#{filename}") 
    end
    seen
  end
  
  def language
    @params['language']
  end
  
  def exercise
    @params['exercise']
  end
  
  def name
    @params['name']
  end
  
  def tab_size
    manifest[:tab_size] || 4
  end
  
  def unit_test_framework
    manifest[:unit_test_framework]  
  end
  
  def browser
    @params[:browser]
  end
  
  def kata_root_dir
    @params[:kata_root]
  end
  
private

  def hidden_filenames
    manifest[:hidden_filenames] || [ ]
  end

  def language_dir
    dir + '/language/' + language
  end
  
  def exercise_dir
    dir + '/exercise/' + exercise
  end
  
  def manifest
    @manifest ||= eval IO.read(language_dir + '/manifest.rb')
  end
  
  def dir
    @params[:filesets_root]  
  end
  
end
