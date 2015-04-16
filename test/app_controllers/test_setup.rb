#!/usr/bin/env ruby

require_relative 'controller_test_base'

class SetupControllerTest < ControllerTestBase

  test 'setup uses cached languages and exercises if present' do
    
    #FIX: this overwrites the cache.json files on the ramdisk. 
    
    languages.dir.write('cache.json', [ 'C++, catch', 'Java, JMock' ])
    exercises.dir.write('cache.json', {
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
         
    # this fails because the exercises/ and languages/ folders
    # contain cache.json files which are used
    
    set_runner_class_name('StubTestRunner')
    dojo.runner.stub_runnable(true)
    languages_names = languages.each.map{|language| language.name}
    exercises_names = exercises.each.map{|exercise| exercise.name}
    language_name = languages_names.shuffle[0]
    exercise_name = exercises_names.shuffle[0]
    id = create_kata(language_name,exercise_name)

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
=begin
  # another test to verify language/exercise default
  # to that of kata's id when id is only 6 chars long.

  #- - - - - - - - - - - - - - - - - - -

  test 'save' do
    stub_dojo
    stub_language('fake-C#','nunit')
    stub_exercise('fake-Yatzy')
    create_kata('fake-C#','fake-Yatzy')
  end
=end

end
