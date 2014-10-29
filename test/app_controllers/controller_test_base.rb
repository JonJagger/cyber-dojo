
ENV['RAILS_ENV'] = 'test'

root = '../..'

require_relative root + '/test/test_coverage'
require_relative root + '/test/all'
require 'test/unit'
require_relative root + '/config/environment'
require 'rails/test_help'

class ControllerTestBase < ActionDispatch::IntegrationTest

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  def thread
    Thread.current
  end

  def setup
    `rm -rf #{root_path}/test/cyberdojo/katas/*`
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
  end

  def teardown
    @disk.teardown if !@disk.nil?
    thread[:disk] = nil
    thread[:git] = nil
    thread[:runner] = nil
  end

  # - - - - - - - - - - - - - - - - - - - - - - - -

  def stub_dojo
    externals = {
      :disk   => @disk   = thread[:disk  ] = SpyDisk.new,
      :git    => @git    = thread[:git   ] = SpyGit.new,
      :runner => @runner = thread[:runner] = StubTestRunner.new
    }
    @dojo = Dojo.new(root_path,externals)
  end

  def stub_language(language_name, unit_test_framework)
    language = @dojo.languages[language_name]
    language.dir.spy_read('manifest.json', {
        'unit_test_framework' => unit_test_framework
    })
  end

  def stub_exercise(exercise_name)
    exercise = @dojo.exercises[exercise_name]
    exercise.dir.spy_read('instructions', 'your task...')
  end

  def stub_kata(id, language_name, exercise_name)
    kata = @dojo.katas[id]
    kata.dir.spy_read('manifest.json', {
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

  def setup_initial_edit(id,avatar_name)
    manifest = {
      'cyber-dojo.sh' => 'mono...',
      'Hiker.cs' => 'class Hiker { ... }'
    }
    path = @dojo.katas[id].avatars[avatar_name].path
    @git.spy(path,'show','0:manifest.json',JSON.unparse(manifest))
  end

  def enter
    if !@id.nil?
      get 'dojo/enter', :format => :json, :id => @id
    else
      get 'dojo/enter', :format => :json
    end
  end

  #- - - - - - - - - - - - - - - - - -

  def json
    ActiveSupport::JSON.decode @response.body
  end

  def html
    @response.body
  end

end
