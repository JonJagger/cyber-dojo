#!/usr/bin/env ../test_wrapper.sh app/controllers

require_relative 'controller_test_base'

class SetupControllerTest < ControllerTestBase

  test 'setup uses cached exercises when present' do    
    set_disk_class_name('HostDisk')
    set_exercises_root(Dir.mktmpdir + '/')
    exercises.dir.write('cache.json', {
      'fake-Print-Diamond'  => 'fake-Print-Diamond instructions',
      'fake-Roman-Numerals' => 'fake-Roman-Numerals instructions'
    })    
    get 'setup/show'    
    FileUtils.remove_entry get_exercises_root    
    assert_response :success
    assert /data-exercise\=\"fake-Print-Diamond/.match(html), "fake-Print-Diamond"
    assert /data-exercise\=\"fake-Roman-Numerals/.match(html), "fake-Roman-Numerals"    
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'setup uses cached languages when present' do    
    set_disk_class_name('HostDisk')
    set_languages_root(Dir.mktmpdir + '/')    
    languages.dir.write('cache.json', [ 'C++, catch', 'Java, JMock' ])    
    get 'setup/show'    
    FileUtils.remove_entry get_languages_root    
    assert_response :success
    assert /data-language\=\"C++/.match(html), "C++"
    assert /data-language\=\"Java/.match(html), "Java"
    assert /data-test\=\"catch/.match(html), "catch"
    assert /data-test\=\"JMock/.match(html), "JMock"
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'setup/show chooses language and exercise of kata ' +
       'whose 10-char id is passed in URL ' +
       '(to encourage repetition)' do
    setup_show(10)    
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'setup/show chooses language and exercise of kata ' +
       'whose 6-char id is passed in URL ' +
       '(to encourage repetition) by using completion' do
    setup_show(6)    
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  
  def setup_show(n)
    # exercises/cache.json was out of date and this test failed.
    # Some code uses cache.json and some code does not. 
    # There is a disconnect between the cache.json files in the
    # exercises/ and languages/ folders and the caches used
    # in Exercises.rb and Languages.rb whose caches do *not*
    # use the disk cache but iterate through their respective
    # folders on disk.    
    
    set_runner_class_name('RunnerStub')
    runner.stub_runnable(true)
    
    languages_names = languages.each.map{|language| language.display_name}.sort
    exercises_names = exercises.each.map{|exercise| exercise.name}.sort    
    language_name = languages_names.shuffle[0]
    exercise_name = exercises_names.shuffle[0]
    id = create_kata(language_name,exercise_name)
    
    get 'setup/show', :id => id[0...n]
    
    assert_response :success
    md = /var selectedExercise = \$\('#exercise_' \+ (\d+)/.match(html)
    selected_exercise = exercises_names[md[1].to_i]    
    assert_equal exercise_name, selected_exercise, 'exercise'
    
    # next bit is trickier than it should be because language.display_name 
    # contains the name of the test framework too.
    md = /var selectedLanguage = \$\('#language_' \+ (\d+)/.match(html)
    just_languages_names = languages_names.each.map {|name| name.split(',')[0].strip }.uniq.sort            
    selected_language = just_languages_names[md[1].to_i]
    assert_equal language_name.split(',')[0].strip, selected_language, 'language'
  end

end
