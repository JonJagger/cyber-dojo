require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../app_models/spy_disk'

class KatasTests < ActionController::TestCase

  def setup
    @disk = SpyDisk.new
    @format = 'rb'
    paas = ExposedLinux::Paas.new(@disk)
    @dojo = paas.create_dojo(root_path + '../../',@format)
  end

  def teardown
    @disk.teardown
  end

  test "dojo.katas.each forwards to katas_each on paas" do
    katas = @dojo.katas.map {|kata| kata.id}
    assert katas.size > 100
    assert katas.all?{|id| id.length == 10}
  end

  test "dojo.katas[id]" do
    kata = @dojo.katas['ABCDE12345']
    assert_equal ExposedLinux::Kata, kata.class
    assert_equal 'ABCDE12345', kata.id
  end

  test "dojo.katas[id].start_avatar" do
    kata = @dojo.katas['ABCDE12345']
    avatar = kata.start_avatar
    assert_equal ExposedLinux::Avatar, avatar.class
    assert_equal 'lion', avatar.name
  end

  test "dojo.make_kata in .rb format" do
    language_name = 'Ruby-Cucumber'
    language = @dojo.languages[language_name]
    @disk[language.path].spy_read('manifest.json', JSON.unparse({
      :unit_test_framework => 'cucumber'
    }))
    exercise_name = 'Print_Diamond'
    exercise = @dojo.exercises[exercise_name]
    @disk[exercise.path].spy_read('instructions', 'your task...')

    kata = @dojo.make_kata(language,exercise)
    manifest = eval(@disk[kata.path].read('manifest.' + @format))
    assert_equal manifest[:exercise], exercise_name
    assert_equal manifest[:language], language_name
  end


  test "dojo.make_kata in .json format" do
    @disk = SpyDisk.new
    @format = 'json'
    paas = ExposedLinux::Paas.new(@disk)
    @dojo = paas.create_dojo(root_path + '../../',@format)
    language_name = 'Ruby-Cucumber'
    language = @dojo.languages[language_name]
    @disk[language.path].spy_read('manifest.json', JSON.unparse({
      :unit_test_framework => 'cucumber'
    }))
    exercise_name = 'Print_Diamond'
    exercise = @dojo.exercises[exercise_name]
    @disk[exercise.path].spy_read('instructions', 'your task...')

    kata = @dojo.make_kata(language,exercise)
    manifest = JSON.parse(@disk[kata.path].read('manifest.' + @format))
    assert_equal manifest['exercise'], exercise_name
    assert_equal manifest['language'], language_name
  end


end
