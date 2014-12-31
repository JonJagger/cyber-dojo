#!/usr/bin/env ruby

require_relative './app_lib_test_base'

class ChooseTests < AppLibTestBase

  include Chooser

  def setup
    thread[:disk] = DiskFake.new
    thread[:git] = Git.new
    thread[:runner] = DummyTestRunner.new
    root_path = 'unused'
    @dojo = Dojo.new(root_path)
    @katas = @dojo.katas
    fake_languages
    fake_exercises
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when no id ' +
       'then choose random known language' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    id=nil
    assert_is_randomly_chosen_language(test_languages_names, id, @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and !katas[id].exists ' +
       'then choose random known language' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    id='012345'
    assert_is_randomly_chosen_language(test_languages_names, id, @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'but language is unknown ' +
       'then choose random known language' do
    test_languages_names.each do |language|
      languages = test_languages_names - [language]
      assert !languages.include?(language)

      kata = make_kata(@dojo, language, 'Fizz_Buzz')
      assert kata.exists?
      id=kata.id
      assert_is_randomly_chosen_language(languages, id, @katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'and language is known ' +
       'then choose that language' do
    test_languages_names.each_with_index do |language,n|
      kata = make_kata(@dojo, language, 'Fizz_Buzz')
      assert kata.exists?
      (1..100).each do
        assert_equal n, choose_language(test_languages_names, kata.id, @katas)
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when no id ' +
       'then choose random known exercise' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    id=nil
    assert_is_randomly_chosen_exercise(test_exercises_names, id, @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'but !katas[id].exist? ' +
       'then choose random known exercise' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    id='123456'
    assert_is_randomly_chosen_exercise(test_exercises_names, id, @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'but exercise is unknown ' +
       'then choose random known exercise' do
    test_exercises_names.each do |exercise|
      exercises = test_exercises_names - [exercise]
      assert !exercises.include?(exercise)
      kata = make_kata(@dojo, 'Ruby-TestUnit', exercise)
      assert kata.exists?
      assert_is_randomly_chosen_exercise(exercises, kata.id, @katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'and exercise is known ' +
       'then choose that exercise' do
    test_exercises_names.each_with_index do |exercise,n|
      kata = make_kata(@dojo, 'Ruby-TestUnit', exercise)
      assert kata.exists?
      (1..42).each do
        assert_equal n, choose_exercise(test_exercises_names, kata.id, @katas)
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def assert_is_randomly_chosen_language(languages, id, katas)
    counts = {}
    (1..100).each do
      n = choose_language(languages, id, katas)
      assert n.is_a? Numeric
      assert n >= 0 && n < languages.length
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
      assert n.is_a? Numeric
      assert n >= 0 && n < exercises.length
      counts[n] ||= 0
      counts[n] += 1
    end
    assert_equal exercises.length, counts.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def test_languages_names
    [ 'C#-NUnit',
      'C++-GoogleTest',
      'Ruby-TestUnit',
      'Java-1.8_JUnit'
    ].sort
  end

  def fake_languages
    test_languages_names.each do |name|
      @dojo.languages[name].dir.write('manifest.json', {})
    end
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

  def fake_exercises
    test_exercises_names.each do |name|
      @dojo.exercises[name].dir.write('instructions', 'content')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def make_kata(dojo, language_name, exercise_name = 'Fizz_Buzz')
    language = dojo.languages[language_name]
    exercise = dojo.exercises[exercise_name]
    dojo.katas.create_kata(language, exercise)
  end

  def thread
    Thread.current
  end

end
