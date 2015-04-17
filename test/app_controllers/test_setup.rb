#!/usr/bin/env ruby

require_relative 'controller_test_base'

class SetupControllerTest < ControllerTestBase

  test 'setup uses cached languages and exercises if present' do    
    set_disk_class_name('Disk')
    set_languages_root(Dir.mktmpdir + '/')    
    languages.dir.write('cache.json', [ 'C++, catch', 'Java, JMock' ])
    exercises.dir.write('cache.json', {
      'fake-Print-Diamond'  => 'fake-Print-Diamond instructions',
      'fake-Roman-Numerals' => 'fake-Roman-Numerals instructions'
    })
    
    get 'setup/show'    
    FileUtils.remove_entry get_languages_root
    
    assert_response :success
    assert /data-language\=\"C++/.match(html), "C++"
    assert /data-language\=\"Java/.match(html), "Java"
    assert /data-test\=\"catch/.match(html), "catch"
    assert /data-test\=\"JMock/.match(html), "JMock"
    assert /data-exercise\=\"fake-Print-Diamond/.match(html), "fake-Print-Diamond"
    assert /data-exercise\=\"fake-Roman-Numerals/.match(html), "fake-Roman-Numerals"
    
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -
  
=begin
  test 'setup/show chooses language and exercise of kata ' +
       'whose 10-char id is passed in URL ' +
       '(to encourage repetition)' do
         
    # this fails because the GET call creates a *new* rails stack
    # and thus a new Dojo and this a new Dojo.runner
    # So I can't dynamically stub. 
    
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
