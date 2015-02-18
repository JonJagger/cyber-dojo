#!/usr/bin/env ruby

require_relative 'controller_test_base'

class SetupControllerTest < ControllerTestBase

  test 'setup uses cached languages and exercises if present' do
    stub_dojo

    languages_dir = disk[@dojo.languages.path]
    languages_dir.write('cache.json', {
      'C++, catch'  => 'C++-catch',
      'Java, JMock' => 'Java-1.8_JMock'
    })

    exercise_dir = disk[@dojo.exercises.path]
    exercise_dir.write('cache.json', {
      'fake-Print-Diamond'  => 'fake-Print-Diamond instructions',
      'fake-Roman-Numerals' => 'fake-Roman-Numerals instructions'
    })

    get 'setup/show'
    assert_response :success

    assert /data-language\=\"C++/.match(html), "C++"
    assert /data-language\=\"Java/.match(html), "Java"

    assert /data-test\=\"catch/.match(html), "catch"
    assert /data-test\=\"JMock/.match(html), "JMock"

    assert /data-exercise\=\"fake-Print-Diamond/.match(html), "fake-Print-Diamond"
    assert /data-exercise\=\"fake-Roman-Numerals/.match(html), "fake-Roman-Numerals"
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -

  test 'setup/show chooses language and exercise of kata ' +
       'whose 10-char id is passed in URL ' +
       '(to encourage repetition)' do
    stub_dojo

    # setup_languages
    languages_names = [
      'fakeC++, catch',
      'fakeC#, NUnit',
      'fakeJava-1.8, JUnit',
      'fakeRuby, TestUnit',
    ].sort

    languages_names.each do |language_name|
      language = @dojo.languages[language_name]
      assert_equal language_name, language.name, 'renamed!'
      stub_language(language_name, 'fake-test-framework-name')
    end

    # setup_exercises
    exercises_names = [
      'fake-Print-Diamond',
      'fake-Recently-Used-List',
      'fake-Roman-Numerals',
      'fake-Yatzy',
    ].sort

    exercises_names.each do |exercise_name|
      stub_exercise(exercise_name)
    end

    language_name = languages_names[2]
    exercise_name = exercises_names[1]
    id = '1234512345'

    stub_kata(id, language_name, exercise_name)

    get 'setup/show', :id => id[0...10]
    assert_response :success

    md = /var selectedExercise = \$\('#exercise_' \+ (\d+)/.match(html)
    selected_exercise = exercises_names[md[1].to_i]
    assert_equal exercise_name, selected_exercise, 'exercise'

    md = /var selectedLanguage = \$\('#language_' \+ (\d+)/.match(html)
    selected_language = languages_names[md[1].to_i]
    assert_equal language_name, selected_language, 'language'
  end

  #- - - - - - - - - - - - - - - - - - -

  # another test to verify language/exercise default
  # to that of kata's id when id is only 6 chars long.

  #- - - - - - - - - - - - - - - - - - -

  test 'save' do
    stub_dojo
    stub_language('fake-C#','nunit')
    stub_exercise('fake-Yatzy')
    create_kata('fake-C#','fake-Yatzy')
  end

end
