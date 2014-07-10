#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative 'integration_test'
require '../lib/SpyDisk'
require '../lib/SpyGit'
require '../lib/StubTestRunner'

class SetupControllerTest  < IntegrationTest

  test 'show' do
    get 'setup/show'
    assert_response :success
  end

  #- - - - - - - - - - - - - - - - - - -

=begin
  test 'setup chooses language and exercise of kata ' +
       'whose 6-char id is passed in URL ' +
       '(to encourage repetition)' do
    setup_dojo

    # setup_languages
    languages_names = [
      'Ruby',
      'C++',
      'C#',
      'Java'
    ]
    languages_names.each do |language_name|
      language = @dojo.languages[language_name]
      language.dir.spy_read('manifest.json', {
          'tab_size' => 4
      })
    end

    # setup_exercises
    exercises_names = [
      'Print-Diamond',
      'Yatzy',
      'Roman-Numerals',
      'Recently-Used-List'
    ]
    exercises_names.each do |exercise_name|
      exercise = @dojo.exercises[exercise_name]
      exercise.dir.spy_read('instructions', 'your task...')
    end

    #
    language_index = 2
    language_name = languages_names[language_index]
    exercise_index = 1
    exercise_name = exercises_names[exercise_index]
    id = '1234512345'
    previous_kata = @dojo.katas[id]
    previous_kata.dir.spy_read('manifest.json', {
      :language => language_name,
      :exercise => exercise_name
    })

    get 'setup/show', :id => id[0...6]

    post 'setup/save', ????

    id = json['id']
    new_kata = @dojo.katas[id]
    assert_equal new_kata.language_name, language_name
    assert_equal new_kata.exercise_name, exercise_name

  end
=end

  #- - - - - - - - - - - - - - - - - - -

  test 'save' do
    checked_save_id
  end

  #- - - - - - - - - - - - - - - - - - -

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

end
