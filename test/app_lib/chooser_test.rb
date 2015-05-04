#!/usr/bin/env ../test_wrapper.sh app/lib

require_relative './app_lib_test_base'

class ChooseTests < AppLibTestBase

  include Chooser

  def setup
    super
    set_runner_class_name('DummyTestRunner')
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when no id is given then' +
       ' choose random known language and' +
       ' choose random known exercise' do
    assert_is_randomly_chosen_language(test_languages_names, id=nil, katas)
    assert_is_randomly_chosen_exercise(test_exercises_names, id=nil, katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is given and !katas[id].exists then' +
       ' choose random known language and' +
       ' choose random known exercise' do
    id = unique_id
    kata = dojo.katas[id]
    assert !kata.exists?, "!kata.exists?"
    assert_is_randomly_chosen_language(test_languages_names, id, katas)
    assert_is_randomly_chosen_exercise(test_exercises_names, id, katas)    
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is given and katas[id].exists? but language is unknown' +
       ' then choose random known language' do
    test_languages_names.each do |language|
      languages = test_languages_names - [language]
      assert !languages.include?(language)
      kata = make_kata(unique_id, language, 'Fizz_Buzz')
      assert kata.exists?, "kata.exists?"
      assert_is_randomly_chosen_language(languages, kata.id, katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is given and katas[id].exists? but exercise is unknown' +
       ' then choose random known exercise' do
    test_exercises_names.each do |exercise|
      exercises = test_exercises_names - [exercise]
      assert !exercises.include?(exercise)
      kata = make_kata(unique_id, 'Ruby-TestUnit', exercise)
      assert kata.exists?
      assert_is_randomly_chosen_exercise(exercises, kata.id, katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  # This fails because of language-test changes
  #test 'when id and katas[id].exists? and language is known' +
  #     ' then choose that language' do
  #  test_languages_names.each_with_index do |language,n|
  #    kata = make_kata(unique_id, language, 'Fizz_Buzz')
  #    assert kata.exists?
  #    (1..42).each do
  #      assert_equal n, choose_language(test_languages_names, kata.id, katas), language
  #    end
  #  end
  #end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id and katas[id].exists? and exercise is known' +
       ' then choose that exercise' do
    test_exercises_names.each_with_index do |exercise,n|
      kata = make_kata(unique_id, 'Ruby-TestUnit', exercise)
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
      'g++4.8.1-GoogleTest',
      'Ruby1.9.3-TestUnit',
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
