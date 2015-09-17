#!/bin/bash ../test_wrapper.sh

require_relative './AppLibTestBase'

class ChooseTests < AppLibTestBase

  include Chooser

  test 'CD36CB',
    'when no id is given then' +
       ' choose random known language and' +
       ' choose random known exercise' do
    assert_is_randomly_chosen_language(test_languages_names, id=nil, katas)
    assert_is_randomly_chosen_exercise(test_exercises_names, id=nil, katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '41EB67',
    'when id is given and !katas[id].exists then' +
       ' choose random known language and' +
       ' choose random known exercise' do
    id = unique_id
    kata = dojo.katas[id]
    refute kata.exists?, "!kata.exists?"
    assert_is_randomly_chosen_language(test_languages_names, id, katas)
    assert_is_randomly_chosen_exercise(test_exercises_names, id, katas)    
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '9671E1',
    "when id is given and katas[id].exists? but kata's language is unknown" +
       ' then choose random language' do
    test_languages_names.each do |unknown_language|
      languages = test_languages_names - [unknown_language]
      refute languages.include?(unknown_language)
      kata = make_kata(unique_id, unknown_language, test_exercises_names.shuffle[0])
      assert kata.exists?, "kata.exists?"
      assert_is_randomly_chosen_language(languages, kata.id, katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test '8D0F94',
    "when id is given and katas[id].exists? but kata's exercise is unknown" +
       ' then choose random exercise' do
    test_exercises_names.each do |unknown_exercise|
      exercises = test_exercises_names - [unknown_exercise]
      refute exercises.include?(unknown_exercise)
      kata = make_kata(unique_id, test_languages_names.shuffle[0], unknown_exercise)
      assert kata.exists?, "kata.exists?"
      assert_is_randomly_chosen_exercise(exercises, kata.id, katas)
    end
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -

  test '773616',
    "when id is given and katas[id].exists? and kata's language is known" +
       ' then choose that language' do
    cmd = test_languages_names.map{ |name| name.split('-').join(', ') }
    test_languages_names.each_with_index do |language,n|
      kata = make_kata(unique_id, language, test_exercises_names.shuffle[0])
      assert kata.exists?
      (1..42).each do
        assert_equal n, choose_language(cmd, kata.id, katas), language
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'D9C2F2',
    "when id is given and katas[id].exists? and kata's exercise is known" +
       ' then choose that exercise' do         
    test_exercises_names.each_with_index do |exercise,n|
      kata = make_kata(unique_id, test_languages_names.shuffle[0], exercise)
      assert kata.exists?
      (1..42).each do
        assert_equal n, choose_exercise(test_exercises_names, kata.id, katas)
      end
    end
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -

  def assert_is_randomly_chosen_language(languages, id, katas)
    counts = {}
    (1..100).each do
      n = choose_language(languages, id, katas)
      assert n.is_a?(Numeric), "n.is_a?(Numeric)"
      assert n >= 0, "n(#{n}) >= 0"
      assert n < languages.length, "n(#{n}) < languages.length"
      counts[n] ||= 0
      counts[n] += 1
    end
    assert_equal languages.length, counts.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def assert_is_randomly_chosen_exercise(exercises, id, katas)
    counts = {}
    (1..100).each do
      n = choose_exercise(exercises, id, katas)
      assert n.is_a?(Numeric), "n.is_a?(Numeric)"
      assert n >= 0, "n(#{n}) >= 0"
      assert n < exercises.length, "n(#{n}) < exercises.length"
      counts[n] ||= 0
      counts[n] += 1
    end
    assert_equal exercises.length, counts.length
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - -

  def test_languages_names
    [ 'C#-NUnit',
      'C++ (g++)-GoogleTest',
      'Ruby-Test::Unit',
      'Java-JUnit'
    ].sort
    
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def test_exercises_names
    ['Yatzy',
     'Roman_Numerals',
     'Leap_Years',
     'Fizz_Buzz',
     'Zeckendorf_Number'
    ].sort
  end

end
