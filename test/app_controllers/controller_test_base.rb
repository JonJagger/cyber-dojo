
ENV['RAILS_ENV'] = 'test'

root = '../..'

require_relative root + '/test/test_coverage'
require_relative root + '/test/all'
require_relative root + '/config/environment'
require_relative root + '/test/TestHelpers'
  
class ControllerTestBase < ActionDispatch::IntegrationTest

  include TestHelpers
  
  # todo: make language_name and exercise_name default to random choices
  def create_kata(language_name = 'Ruby, TestUnit', exercise_name = 'Yatzy')
    parts = language_name.split(',')
    params = { 
      :language => parts[0].strip,
      :test => parts[1].strip,
      :exercise => exercise_name
    }
    get 'setup/save', params
    @id = json['id']
  end
    
  def enter
    params = { :format => :json }
    params[:id] = @id if !@id.nil?
    get 'dojo/enter', params
    @avatar_name = avatar_name
  end
    
  def re_enter
    params = { :format => :json, :id => @id }
    get 'dojo/re_enter', params
    assert_response :success    
  end

  def kata_edit
    params = { :id => @id, :avatar_name => @avatar_name }
    get 'kata/edit', params
    assert_response :success
  end
    
  def kata_run_tests(params)
    defaults = { :format => :js, :id => @id, :avatar => @avatar_name }
    post 'kata/run_tests', params.merge(defaults)
  end

  def make_file_hash(filename,content,incoming,outgoing)
    { file_content:         { filename => content },
      file_hashes_incoming: { filename => incoming },
      file_hashes_outgoing: { filename => outgoing }
    }
  end
    
  def any_test
    filename = 'cyber-dojo.sh'
    kata_run_tests make_file_hash(filename,'',234234,-4545645678)
  end
    
  def json
    ActiveSupport::JSON.decode @response.body
  end

  def html
    @response.body
  end
  
  def avatar_name
    json['avatar_name']
  end
  
=begin
  def stub_setup
    stub_dojo
    stub_language('fake-C#','nunit')
    stub_exercise('fake-Yatzy')
    @id = create_kata('fake-C#','fake-Yatzy')
  end

  def stub_dojo
    reset_external(:disk, DiskFake.new)
    reset_external(:git, GitSpy.new)
    reset_external(:runner, TestRunnerStub.new)
    @dojo = Dojo.new
  end

  def stub_language(language_name, unit_test_framework)
    language = @dojo.languages[language_name]
    language.dir.write('manifest.json', 
      { 
        'unit_test_framework' => unit_test_framework,
        'display_name' => language_name.gsub('-',',')
      })
  end

  def stub_exercise(exercise_name)
    exercise = @dojo.exercises[exercise_name]
    exercise.dir.write('instructions', 'your task...')
  end

  def stub_kata(id, language_name, exercise_name)
    kata = @dojo.katas[id]
    kata.dir.write('manifest.json', { language:language_name,
                                      exercise:exercise_name })
  end

  def amber_test
    any_test
  end

private

  def root_path
    File.absolute_path(File.dirname(__FILE__) + '/../../')
  end
=end
  
end
