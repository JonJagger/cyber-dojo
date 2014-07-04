#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class ChooseTests < CyberDojoTestBase

  def setup
    super
    externals = {
      :disk => OsDisk.new,
      :git => Git.new,
      :runner => DummyTestRunner.new
    }
    @dojo = Dojo.new(root_path,externals)
    @katas = @dojo.katas
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when no id ' +
       'then choose random known language' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    assert_is_randomly_chosen_language(test_languages_names, id=nil, @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and !katas[id].exists ' +
       'then choose random known language' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    assert_is_randomly_chosen_language(test_languages_names, id='012345', @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'but language is unknown ' +
       'then choose random known language' do
    test_languages_names.each do |language|
      languages = test_languages_names - [language]
      assert !languages.include?(language)
      kata = make_kata(@dojo, language, 'test_Yahtzee')
      assert kata.exists?
      assert_is_randomly_chosen_language(languages, id=kata.id, @katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'and language is known ' +
       'then choose that language' do
    test_languages_names.each_with_index do |language,n|
      kata = make_kata(@dojo, language, 'test_Yahtzee')
      assert kata.exists?
      (1..100).each do
        assert_equal n, Choose::language(test_languages_names, kata.id, @katas)
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when no id ' +
       'then choose random known exercise' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    assert_is_randomly_chosen_exercise(test_exercises_names, id=nil, @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'but !katas[id].exist? ' +
       'then choose random known exercise' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
    assert_is_randomly_chosen_exercise(test_exercises_names, id='123456', @katas)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'but exercise is unknown ' +
       'then choose random known exercise' do
    test_exercises_names.each do |exercise|
      exercises = test_exercises_names - [exercise]
      assert !exercises.include?(exercise)
      kata = make_kata(@dojo, 'Ruby-installed-and-working', exercise)
      assert kata.exists?
      assert_is_randomly_chosen_exercise(exercises, id=kata.id, @katas)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when id ' +
       'and katas[id].exists? ' +
       'and exercise is known ' +
       'then choose that exercise' do
    test_exercises_names.each_with_index do |exercise,n|
      kata = make_kata(@dojo, 'Ruby-installed-and-working', exercise)
      assert kata.exists?
      (1..42).each do
        assert_equal n, Choose::exercise(test_exercises_names, kata.id, @katas)
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def assert_is_randomly_chosen_language(languages, id, katas)
    counts = {}
    (1..100).each do
      n = Choose::language(languages, id, katas)
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
      n = Choose::exercise(exercises, id, katas)
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
      'Ruby-installed-and-working',
      'test-Java-JUnit'
    ].sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def test_exercises_names
    ['test_Yahtzee',
     'test_Roman_Numerals',
     'test_Leap_Years',
     'test_Fizz_Buzz',
     'test_Zeckendorf'
    ].sort
  end

end
