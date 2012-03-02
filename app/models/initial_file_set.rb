
# > ruby test/functional/initial_file_set_tests.rb

class InitialFileSet
  
  def initialize(params)
    @params = params
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
  
  def hidden_filenames
    manifest[:hidden_filenames] || [ ]
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
  
  def katas_root_dir
    dir + '/katas'
  end
  
private

  def language_dir
    dir + '/languages/' + language
  end
  
  def exercise_dir
    dir + '/exercises/' + exercise
  end
  
  def manifest
    @manifest ||= eval IO.read(language_dir + '/manifest.rb')
  end
  
  def dir
    @params[:root_dir]  
  end
  
end
