require_relative '../test_helper'
require '../lib/SpyDisk'
require '../lib/SpyGit'
require '../lib/StubTestRunner'

class ControllerTestBase < ActionController::IntegrationTest

  def setup
    # calls test_helper's ActiveSupport::TestCase::setup
    # (from test_helper) which does `rm -rf #{root_path}/katas/*`
    super
    # used in application_controller.root_path()
    ENV['CYBERDOJO_TEST_ROOT_DIR'] = 'true'
  end

  def thread
    Thread.current
  end

  def setup_dojo
    externals = {
      :disk   => @disk   = thread[:disk  ] = SpyDisk.new,
      :git    => @git    = thread[:git   ] = SpyGit.new,
      :runner => @runner = thread[:runner] = StubTestRunner.new
    }
    @dojo = Dojo.new(root_path,externals)
  end

  def setup_language(language_name, unit_test_framework)
    language = @dojo.languages[language_name]
    language.dir.spy_read('manifest.json', {
        'unit_test_framework' => unit_test_framework
    })
  end

  def setup_exercise(exercise_name)
    exercise = @dojo.exercises[exercise_name]
    exercise.dir.spy_read('instructions', 'your task...')
  end

  def setup_kata(id, language_name, exercise_name)
    kata = @dojo.katas[id]
    kata.dir.spy_read('manifest.json', {
      :language => language_name,
      :exercise => exercise_name
    })
  end

  def checked_save_id(language_name = 'Ruby-installed-and-working',
                      exercise_name = 'test_Yahtzee')
    # currently does not set Thread.current[:disk] etc
    post 'setup/save',
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

  #- - - - - - - - - - - - - - - - - -

  def teardown
    @disk.teardown if !@disk.nil?
    thread[:disk] = nil
    thread[:git] = nil
    thread[:runner] = nil
  end

  def json
    ActiveSupport::JSON.decode @response.body
  end

  def html
    @response.body
  end

end
