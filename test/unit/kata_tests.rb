require File.dirname(__FILE__) + '/../test_helper'

class KataTests < ActionController::TestCase
  
  def language
    'Ruby-installed-and-working'  
  end
  
  test "create new named kata creates manifest with required properies" do
    id = 'ABCDABCD34'
    now = [2012,3,3,10,6,12]
    info = make_info(language, 'Yahtzee', id, now)
    Kata.create_new(root_dir, info)
    kata = Kata.new(root_dir, info[:id])
    
    assert_equal root_dir + '/katas/AB/CDABCD34', kata.dir
    assert File.directory?(kata.dir), "File.directory?(#{kata.dir})"
        
    manifest_rb = kata.dir + '/manifest.rb'
    assert File.exists?(manifest_rb), "File.exists?(#{manifest_rb})"
    manifest = eval(IO.read(manifest_rb))
    assert manifest.has_key?(:visible_files),
          "manifest.has_key?(:visible_files)"
    
    assert_equal manifest[:visible_files], kata.language.visible_files
    assert_equal 'Yahtzee', kata.exercise.name
    assert_equal language, kata.language.name
    assert_equal id, kata.id
    assert_equal Time.mktime(*now), kata.created
    assert_equal 'ruby_test_unit', kata.language.unit_test_framework
    assert_equal " " * 2, kata.language.tab
    seconds = 5
    now = now[0...-1] + [now.last + seconds ]
    assert_equal seconds, kata.age_in_seconds(Time.mktime(*now))
  end
      
  test "root katas dir initially does not contain an index file" do
    assert !File.exists?(root_dir + '/katas/index.rb');
  end
  
  test "Kata.exists? returns false before kata is created and true after kata is created" do
    id = 'AABBCCDDEE'
    info = make_info(language, 'Yahtzee', id)
    assert !Kata.exists?(root_dir, id)
    Kata.create_new(root_dir, info)
    assert Kata.exists?(root_dir, id)
  end
      
  test "creating a new kata succeeds and creates katas root dir" do
    kata = make_kata(language)
    assert File.exists?(kata.dir), 'inner/outer dir created'
  end
    
  test "you can create an avatar in a kata" do
    kata = make_kata(language) 
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    assert 'hippo', avatar.name
  end
  
  test "multiple avatar_names in a kata" do
    kata = make_kata(language)
    Avatar.new(kata, 'lion')
    Avatar.new(kata, 'hippo')
    assert_equal ['hippo', 'lion'], kata.avatar_names.sort
  end

end
