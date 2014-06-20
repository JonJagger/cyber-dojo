#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../cyberdojo_test_base'
require 'Choose'
require 'OsDisk'
require 'Git'
require 'DummyTestRunner'
require 'Dojo'
require 'Katas'
require 'Kata'
require 'Id'
require 'Languages'
require 'Language'
require 'Exercises'
require 'Exercise'

class ChooseTests < CyberDojoTestBase
  include Externals

  def setup
    super
    set_disk(OsDisk.new)
    set_git(Git.new)
    set_runner(DummyTestRunner.new)
    @dojo = Dojo.new(root_path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def assert_is_randomly_chosen_language(languages, params_id, kata)
    counts = {}
    (1..100).each do
      n = Choose::language(languages, params_id, kata)
      assert n.is_a? Numeric
      assert n >= 0 && n < languages.length
      counts[n] ||= 0
      counts[n] += 1
    end
    assert_equal languages.length, counts.length
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

  test 'when no params[:id] ' +
       'then choose random known language' do
    kata = @dojo.katas['01234556789']
    assert !kata.exists?
    assert_is_randomly_chosen_language(test_languages_names, params_id=nil, kata)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when params[:id] ' +
       'and !katas[id].exists ' +
       'then choose random known language' do
    kata = @dojo.katas['0123456789']
    assert !kata.exists?
    assert_is_randomly_chosen_language(test_languages_names, params_id='012345', kata)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test 'when params[:id] ' +
       'and katas[id].exists? ' +
       'but language is unknown ' +
       'then choose random known language' do
    test_languages_names.each do |language|
      languages = test_languages_names - [language]
      assert !languages.include?(language)
      kata = make_kata(@dojo, language, 'test_Yahtzee')
      assert kata.exists?
      assert_is_randomly_chosen_language(languages, params_id=kata.id.to_s, kata)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test "when params[:id] " +
       "and katas[id].exists? " +
       "and language is known " +
       "then choose that language" do
    test_languages_names.each_with_index do |language,n|
      kata = make_kata(@dojo, language, 'test_Yahtzee')
      id = kata.id.to_s
      assert kata.exists?
      (1..100).each do
        assert_equal n, Choose::language(test_languages_names, id, kata)
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  def assert_is_randomly_chosen_exercise(exercises, params_id, kata)
    counts = {}
    (1..100).each do
      n = Choose::exercise(exercises, params_id, kata)
      assert n.is_a? Numeric
      assert n >= 0 && n < exercises.length
      counts[n] ||= 0
      counts[n] += 1
    end
    assert_equal exercises.length, counts.length
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

  #- - - - - - - - - - - - - - - - - - - - - - -

  test "when no params[:id] " +
       "then choose random known exercise" do
    kata = @dojo.katas['01234556789']
    assert !kata.exists?
    assert_is_randomly_chosen_exercise(test_exercises_names, params_id=nil, kata)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test "when params[:id] " +
       "but !katas[id].exist? " +
       "then choose random known exercise" do
    kata = @dojo.katas['0123456789']
    assert !kata.exists?
    assert_is_randomly_chosen_exercise(test_exercises_names, params_id='012345', kata)
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test "when params[:id] " +
       "and katas[id].exists? " +
       "but exercise is unknown " +
       "then choose random known exercise" do
    test_exercises_names.each do |exercise|
      exercises = test_exercises_names - [exercise]
      assert !exercises.include?(exercise)
      kata = make_kata(@dojo, 'Ruby-installed-and-working', exercise)
      assert kata.exists?
      assert_is_randomly_chosen_exercise(exercises, params_id=kata.id.to_s, kata)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - -

  test "when params[:id] " +
       "and katas[id].exists? " +
       "and exercise is known " +
       "then choose that exercise" do
    test_exercises_names.each_with_index do |exercise,n|
      kata = make_kata(@dojo, 'Ruby-installed-and-working', exercise)
      id = kata.id.to_s
      assert kata.exists?
      (1..42).each do
        assert_equal n, Choose::exercise(test_exercises_names, id, kata)
      end
    end
  end

end
