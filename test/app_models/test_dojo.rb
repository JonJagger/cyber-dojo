#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class DojoTests < ModelTestCase

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "ctor raises if thread[:git] not set" do
    Thread.current[:git] = nil
    assert_raise RuntimeError do
      Dojo.new('fake/')
    end
  end

  # ctor raises if thread[:git] not set
  # ctor raises if thread[:runner] not set
  # ctor raises if exercises_dir_env_var_not_set
  # ctor raises if languages_dir_env_var_not_set
  # ctor raises if katas_dir_env_var_not_set

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'default format is json' do
    assert_equal 'json', Dojo.new(path='fake/').format
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'format is as set in ctor' do
    assert_equal 'json', Dojo.new(path='fake/', 'json').format
    assert_equal 'rb',   Dojo.new(path='fake/', 'rb').format
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo created with format not json or rb raises' do
    assert_raise RuntimeError do
      Dojo.new('fake/', 'wibble')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "c'tor format determines kata's manifest format" do
    json_and_rb do |fmt|
      language = @dojo.languages['Java-JUnit']
      language.dir.spy_read('manifest.json', { :unit_test_framework => 'JUnit' })
      exercise = @dojo.exercises['test_Yahtzee']
      exercise.dir.spy_read('instructions', 'your task...')
      kata = @dojo.katas.create_kata(language, exercise)
      assert_equal 'manifest.'+fmt, kata.manifest_filename
      assert filenames_written_to(kata.dir.log).include?('manifest.'+fmt)
    end
  end

end
