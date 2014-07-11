#!/usr/bin/env ruby

require_relative 'integration_test'
require '../lib/SpyDisk'
require '../lib/SpyGit'
require '../lib/StubTestRunner'

class SetupControllerTest < IntegrationTest

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

  #- - - - - - - - - - - - - - - - - - -

  test 'setup/show chooses language and exercise of kata ' +
       'whose 10-char id is passed in URL ' +
       '(to encourage repetition)' do
    setup_dojo

    # setup_languages
    languages_names = [
      'fake-C++',
      'fake-C#',
      'fake-Java',
      'fake-Ruby',
    ].sort

    languages_names.each do |language_name|
      language = @dojo.languages[language_name]
      assert_equal language.name, language.new_name, 'renamed!'
      language.dir.spy_read('manifest.json', {
          'unit_test_framework' => 'fake'
      })
    end

    # setup_exercises
    exercises_names = [
      'fake-Print-Diamond',
      'fake-Recently-Used-List',
      'fake-Roman-Numerals',
      'fake-Yatzy',
    ].sort

    exercises_names.each do |exercise_name|
      exercise = @dojo.exercises[exercise_name]
      assert_equal exercise.name, exercise.new_name, 'renamed!'
      exercise.dir.spy_read('instructions', 'your task...')
    end

    language_name = languages_names[2]
    exercise_name = exercises_names[1]
    id = '1234512345'
    previous_kata = @dojo.katas[id]
    previous_kata.dir.spy_read('manifest.json', {
      :language => language_name,
      :exercise => exercise_name
    })

    get 'setup/show', :id => id[0...10]
    assert_response :success

    md = /var selected = \$\('#exercise_' \+ (\d+)/.match(html)
    selected_exercise = exercises_names[md[1].to_i]
    assert_equal exercise_name, selected_exercise, 'exercise'

    md = /var selected = \$\('#language_' \+ (\d+)/.match(html)
    selected_language = languages_names[md[1].to_i]
    assert_equal language_name, selected_language, 'language'

  end

  #- - - - - - - - - - - - - - - - - - -

  # another test to verify language/exercise default
  # to that of kata's id when id is only 6 chars long.
  # This will need disk abstraction in lib/Folders.
  # Or would this be better as a separate test dedicated
  # to just the id completion...

  #- - - - - - - - - - - - - - - - - - -

  test 'save' do
    checked_save_id
  end

end
