require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

# > ruby test/functional/kata_tests.rb

class KataTests < ActionController::TestCase

  include Files
  extend Files
  
  test "create new using uuid" do
    params = make_params('Dummy')
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]    
    kata = Kata.new(params)
    assert File.directory?(kata.dir), "File.directory?(#{kata.dir})"
        
    manifest_rb = kata.dir + '/manifest.rb'
    assert File.exists?(manifest_rb), "File.exists?(#{manifest_rb})"
    manifest = eval(IO.read(manifest_rb))
    assert_equal 'Yahtzee', manifest[:exercise]
    assert_equal 'Yahtzee', info[:exercise]
    assert_equal 'Dummy', manifest[:language]
    assert_equal 'Dummy', info[:language]
    assert_equal 'Jon Jagger', manifest[:name]
    assert_equal 'Jon Jagger', info[:name]
    assert_equal info[:id], manifest[:id]
    assert info.has_key?(:created), "info.has_key?(:created)"
    assert manifest.has_key?(:created), "manifest.has_key?(:created)"
    assert_equal info[:created], manifest[:created]
    
    assert !info.has_key?(:visible_files),
          "!info.has_key?(:visible_files)"
    assert !info.has_key?(:unit_test_framework),
          "!info.has_key?(:unit_test_framework)"
    assert !info.has_key?(:tab_size),
          "!info.has_key?(:tab_size)"
  end
  
  test "root katas dir initially does not contain an index file" do
    assert !File.exists?(root_dir + '/katas/index.rb');
  end
    
  test "creating a new kata succeeds and creates katas root dir" do
    kata = make_kata('Dummy')
    assert File.exists?(kata.dir), 'inner/outer dir created'
  end
    
  test "you can create an avatar in a kata" do
    kata = make_kata('Dummy') 
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    assert 'hippo', avatar.name
  end
  
  test "age in seconds" do
    kata = make_kata('Dummy') 
    assert_equal 0, kata.age_in_seconds    
  end
  
  test "multiple avatar names in a kata" do
    kata = make_kata('Dummy')
    Avatar.new(kata, 'lion')
    Avatar.new(kata, 'hippo')
    assert_equal ['hippo', 'lion'], kata.avatar_names.sort
  end
  
  test "all increments initially empty" do
    kata = make_kata('Dummy')
    Avatar.new(kata, 'lion')
    Avatar.new(kata, 'hippo')
    expected = { "hippo" => [ ], "lion" => [ ] }
    assert_equal expected, kata.all_increments
  end
      
end
