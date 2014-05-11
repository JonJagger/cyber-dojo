require File.dirname(__FILE__) + '/../test_helper'

class ChooseTests < ActionController::TestCase

  def setup
    super
    @disk = OsDisk.new
    @git = Git.new
    @runner = NullRunner.new
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = 'json'
    @dojo = @paas.create_dojo(root_path, @format)
  end

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

  test "when no params[:id] then choose random entry from languages" do
    languages = ['C', 'Ruby', 'Python', 'C++']
    kata = @dojo.katas['01234556789']
    assert !kata.exists?
    assert_is_randomly_chosen_language(languages, params_id=nil, kata)
  end

  test "when params[:id] but kata(id) does not exist then choose random entry from languages" do
    languages = ['C', 'Ruby', 'Python', 'C++']
    kata = @dojo.katas['0123456789']
    assert !kata.exists?
    assert_is_randomly_chosen_language(languages, params_id='012345', kata)
  end

  test "when params[:id] and kata(id) exists but its language is not one of languages then choose random entry from languages" do
    languages = [ 'C', 'Python', 'Ruby', 'Clojure', 'Java' ]
    language = 'Ruby-installed-and-working'
    assert !languages.include?(language)
    kata = make_kata(@dojo, language, 'Yahtzee')
    assert kata.exists?
    assert_is_randomly_chosen_language(languages, params_id=kata.id.to_s, kata)
  end

  def assert_chosen_language(languages, id, kata, choice)
    (1..100).each do
      n = Choose::language(languages, id, kata)
      assert_equal choice, n, "#{languages[choice]} #{kata.language.name}"
    end
  end

  test "when params[:id] and kata(id) exists and its language is one of languages choose it" do
    languages = [ 'C#-NUnit',
                  'C++-GoogleTest',
                  'Ruby-installed-and-working',
                  'test-Java-JUnit' ]
    languages.each_with_index do |language,n|
      kata = make_kata(@dojo, language, 'Yahtzee')
      assert kata.exists?
      assert_chosen_language(languages, kata.id.to_s, kata, n)
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

  def test_exercises_names
    ['test_Yahtzee',
     'test_Roman_Numerals',
     'test_Leap_Years',
     'test_Fizz_Buzz',
     'test_Zeckendorf'
    ].sort
  end

  test "when no params[:id] then choose random entry from exercises" do
    kata = @dojo.katas['01234556789']
    assert !kata.exists?
    assert_is_randomly_chosen_exercise(test_exercises_names, params_id=nil, kata)
  end

  test "when params[:id] but kata(id) does not exist then choose random entry from exercises" do
    kata = @dojo.katas['0123456789']
    assert !kata.exists?
    assert_is_randomly_chosen_exercise(test_exercises_names, params_id='012345', kata)
  end

  test "when params[:id] and kata(id) exists but its exercise is not one of exercises then choose random entry from exercises" do
    exercise = 'test_Yahtzee'
    exercises = test_exercises_names - [exercise]
    assert !exercises.include?(exercise)
    kata = make_kata(@dojo, 'Ruby-installed-and-working', exercise)
    assert kata.exists?
    assert_is_randomly_chosen_exercise(exercises, params_id=kata.id.to_s, kata)
  end

  test "when params[:id] and kata(id) exists and its exercise is one of exercises choose it" do
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
