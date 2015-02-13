
ENV['RAILS_ENV'] = 'test'

root = '../..'

require_relative root + '/test/test_coverage'
require_relative root + '/test/all'
require_relative root + '/config/environment'
require 'minitest/autorun'
require 'rails/test_help'

class ControllerTestBase < ActionDispatch::IntegrationTest

  include ExternalSetter
  include ExternalDiskDir
  include ExternalGit
  include ExternalRunner
  include ExternalExercisesPath
  include ExternalLanguagesPath
  include ExternalKatasPath

  def setup
    reset_external(:disk, Disk.new)
    reset_external(:git, Git.new)
    reset_external(:runner, HostTestRunner.new)
    reset_external(:exercises_path, root_path + '/exercises/')
    reset_external(:languages_path, root_path + '/languages/')
    reset_external(:katas_path, root_path + '/test/cyberdojo/katas/')
    `rm -rf #{Dojo.new.katas.path}*`
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

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
    language.dir.write('manifest.json', {
        'unit_test_framework' => unit_test_framework
    })
  end

  def stub_exercise(exercise_name)
    exercise = @dojo.exercises[exercise_name]
    exercise.dir.write('instructions', 'your task...')
  end

  def stub_kata(id, language_name, exercise_name)
    kata = @dojo.katas[id]
    kata.dir.write('manifest.json', {
      :language => language_name,
      :exercise => exercise_name
    })
  end

  def create_kata(language_name = 'Ruby-TestUnit',
                  exercise_name = 'Yatzy')
    get 'setup/save',
      :language => language_name,
      :exercise => exercise_name

    json['id']
  end

  def enter
    if @id.nil?
      get 'dojo/enter', :format => :json
    else
      get 'dojo/enter', :format => :json, :id => @id
    end
    @avatar_name = avatar_name
  end

  def kata_edit
    get 'kata/edit', :id => @id, :avatar => @avatar_name
    assert_response :success
  end

  def any_test
    kata_run_tests :file_content => {
        'cyber-dojo.sh' => ''
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }
  end

  def kata_run_tests(hash)
    hash[:format] = :js
    hash[:id] = @id
    hash[:avatar] = @avatar_name
    post 'kata/run_tests', hash
  end

  def avatar_name
    json['avatar_name']
  end

  def show_dashboard(hash =  {})
    hash[:id] = @id
    get 'dashboard/show', hash
    assert_response :success
  end

  def json
    ActiveSupport::JSON.decode @response.body
  end

  def html
    @response.body
  end

private

  def root_path
    File.absolute_path(File.dirname(__FILE__) + '/../../')
  end

end
