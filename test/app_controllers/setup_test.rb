#!/bin/bash ../test_wrapper.sh

require_relative 'controller_test_base'

# DiskFakeAdapter ensures multiple threads all use the same DiskFake object.
# Is there a way to force rails to use a single thread?

class DiskFakeAdapter

  def method_missing(sym, *args, &block)
    @@disk ||= DiskFake.new
    @@disk.send(sym, *args, &block)
  end

  def self.reset
    @@disk = nil
  end

end

# - - - - - - - - - - - - - - - - - - - - - -

class SetupControllerTest < ControllerTestBase

  def setup
    super
    set_disk_class('DiskFakeAdapter')
    setup_exercises_cache
    setup_languages_cache
  end

  def teardown
    super
    DiskFakeAdapter.reset
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'setup page uses cached exercises' do
    get 'setup/show'
    assert_response :success
    assert /data-exercise\=\"#{print_diamond}/.match(html), print_diamond
    assert /data-exercise\=\"#{roman_numerals}/.match(html), roman_numerals
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -

  test 'setup page uses cached languages' do
    get 'setup/show'
    assert_response :success
    assert /data-language\=\"C++/.match(html), 'C++'
    assert /data-language\=\"Asm/.match(html), 'Asm'
    assert !/data-language\=\"Java/.match(html), 'Java'
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
    set_runner_class('RunnerStubTrue')
    
    languages_display_names = languages.map {|language| language.display_name}.sort    
    language_display_name = languages_display_names.shuffle[0]
    
    exercises_names = exercises.map {|exercise| exercise.name}.sort        
    exercise_name = exercises_names.shuffle[0]
    
    id = create_kata(language_display_name,exercise_name)
        
    get 'setup/show', :id => id[0...n]
    
    assert_response :success
    
    md = /var selectedExercise = \$\('#exercise_' \+ (\d+)/.match(html)
    selected_exercise = exercises_names[md[1].to_i]    
    assert_equal exercise_name, selected_exercise, 'exercise'
    
    # next bit is trickier than it should be because language.display_name 
    # contains the name of the test framework too.
    md = /var selectedLanguage = \$\('#language_' \+ (\d+)/.match(html)
    languages_names = languages_display_names.map {|name| get_language_from(name) }.uniq.sort     
    selected_language = languages_names[md[1].to_i]
    assert_equal get_language_from(language_display_name), selected_language, 'language'    
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def setup_languages_cache
    languages_cache = {
      'Asm, assert' => {
        :dir_name => 'Asm',
        :test_dir_name => 'assert'
      },
      'C++ (g++), assert' => {
        :dir_name => 'g++4.8.4',
        :test_dir_name => 'assert'
      }
    }
    languages.dir.write('cache.json', languages_cache)
    languages_cache.keys.each do |display_name|
      key = get_language_from(display_name) + '-' + get_test_from(display_name)
      languages[key].dir.write('manifest.json', { :display_name => display_name})      
    end    
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def setup_exercises_cache
    exercises.dir.write('cache.json', {
      print_diamond  => 'print diamond instructions',
      roman_numerals => 'roman numerals instructions'
    })
    exercises[print_diamond].dir.write('instructions', 'aaa')
    exercises[roman_numerals].dir.write('instructions', 'bbb')
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  
  def commad(s); s.split(','); end
  def get_language_from(name); commad(name)[0].strip; end
  def get_test_from(name); commad(name)[1].strip; end
  
  # - - - - - - - - - - - - - - - - - - - - - -

  def print_diamond; 'Print_Diamond'; end
  def roman_numerals; 'Roman_Numerals'; end
  
end
