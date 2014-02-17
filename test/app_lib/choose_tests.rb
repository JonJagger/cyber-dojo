require File.dirname(__FILE__) + '/../test_helper'
require 'Choose'

class ChooseTests < ActionController::TestCase

  test "when no params[:id] then choose random entry from languages" do
    languages = ['C', 'Ruby', 'Python', 'C++']
    params_id = nil
    actual = Choose::language(languages, params_id, :unused, :unused)
    assert actual.is_a? Numeric
    assert actual >= 0 && actual < languages.length
  end    

  test "when params[:id] but kata(id) does not exist then choose random entry from languages" do
    languages = ['C', 'Ruby', 'Python', 'C++']
    params_id = '012345'
    id = '0123456789'
    actual = Choose::language(languages, params_id, id, @cd.dir)
    assert actual.is_a? Numeric
    assert actual >= 0 && actual < languages.length    
  end
  
  test "when params[:id] and kata(id) exists and its language is one of languages choose it" do
    language = 'Ruby-installed-and-working'
    languages = [ 'C', 'Python', language, 'C++', 'Clojure' ]
    kata = make_kata(language, 'Yahtzee')
    actual = Choose::language(languages, kata.id, kata.id, @cd.dir)
    assert actual.is_a? Numeric
    assert_equal languages.index(language), actual
  end
  
  test "when params[:id] and kata(id) exists but its language is not one of languages then choose random entry from languages" do
    language = 'Ruby-installed-and-working'
    languages = [ 'C', 'Python', 'Ruby', 'Clojure', 'Java' ]
    kata = make_kata(language, 'Yahtzee')
    actual = Choose::language(languages, kata.id, kata.id, @cd.dir)
    assert actual.is_a? Numeric
    assert actual >= 0 && actual < languages.length        
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -
  
  test "when no params[:id] then choose random entry from exercises" do
    exercises = ['Yahtzee', 'Roman Numerals', 'Leap Years', 'Fizz Buzz']
    params_id = nil
    actual = Choose::exercise(exercises, params_id, :unused, :unused)
    assert actual.is_a? Numeric
    assert actual >= 0 && actual < exercises.length
  end    

  test "when params[:id] but kata(id) does not exist then choose random entry from exercises" do
    exercises = ['Yahtzee', 'Roman Numerals', 'Leap Years', 'Fizz Buzz']
    params_id = '012345'
    id = '0123456789'
    actual = Choose::exercise(exercises, params_id, id, @cd.dir)
    assert actual.is_a? Numeric
    assert actual >= 0 && actual < exercises.length    
  end
  
  test "when params[:id] and kata(id) exists and its exercise is one of exercises choose it" do
    exercise = 'Yahtzee'
    exercises = [ 'Leap Years', 'Roman Numerals', exercise, 'Fizz Buzz', 'Zeckendorf' ]
    kata = make_kata('Ruby-installed-and-working', exercise)
    actual = Choose::exercise(exercises, kata.id, kata.id, @cd.dir)
    assert actual.is_a? Numeric
    assert_equal exercises.index(exercise), actual
  end
  
  test "when params[:id] and kata(id) exists but its exercise is not one of exercises then choose random entry from exercises" do
    exercise = 'Yahtzee'
    exercises = [ 'Leap Years', 'Roman Numerals', 'Fizz Buzz', 'Zeckendorf' ]
    kata = make_kata('Ruby-installed-and-working', exercise)
    actual = Choose::exercise(exercises, kata.id, kata.id, @cd.dir)
    assert actual.is_a? Numeric
    assert actual >= 0 && actual < exercises.length        
  end
  
end

