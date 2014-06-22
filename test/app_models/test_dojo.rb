#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class DojoTests < ModelTestCase

  test "ctor raises if thread[:git] not set" do
    externals = {
      :disk => dummy,
      :runner => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake/','json',externals)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "ctor raises if thread[:disk] not set" do
    externals = {
      :git => dummy,
      :runner => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake/','json',externals)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "ctor raises if thread[:runner] not set" do
    externals = {
      :disk => dummy,
      :git => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake/','json', externals)
    end
  end

  # ctor raises if exercises_dir_env_var_not_set
  # ctor raises if languages_dir_env_var_not_set
  # ctor raises if katas_dir_env_var_not_set

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'format is as set in ctor' do
    externals = {
      :disk => dummy,
      :git => dummy,
      :runner => dummy
    }
    assert_equal 'json', Dojo.new(path='fake/','json',externals).format
    assert_equal 'rb',   Dojo.new(path='fake/','rb',externals).format
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dojo created with format not json or rb raises' do
    externals = {
      :disk => dummy,
      :git => dummy,
      :runner => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake/','wibble',externals)
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

  def dummy
    Object.new
  end

end
