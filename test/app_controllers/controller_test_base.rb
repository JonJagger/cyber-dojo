require_relative '../test_helper'
require '../lib/SpyDisk'
require '../lib/SpyGit'
require '../lib/StubTestRunner'

class ControllerTestBase < ActionController::IntegrationTest

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

  def checked_save_id(language_name = 'Ruby-TestUnit',
                      exercise_name = 'Yatzy')
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

  def json
    ActiveSupport::JSON.decode @response.body
  end

  def html
    @response.body
  end

end
