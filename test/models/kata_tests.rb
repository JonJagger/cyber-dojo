require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'

class KataTests < ActionController::TestCase

  def setup
    @stub_file = StubDiskFile.new
    @stub_git = StubDiskGit.new
    Thread.current[:file] = @stub_file
    Thread.current[:git] = @stub_git
  end

  def teardown
    Thread.current[:file] = nil
    Thread.current[:git] = nil
  end

  def root_dir
    (Rails.root + 'test/cyberdojo').to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "creation saves manifest in kata dir" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)    
    assert_equal [ [ 'manifest.rb', info.inspect ] ], @stub_file.write_log[kata.dir]    
    assert_equal nil, @stub_file.read_log[kata.dir]
  end

  test "id is from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal info[:id], kata.id    
  end

  test "dir does not end in slash" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert !kata.dir.end_with?(@stub_file.separator),
          "!#{kata.dir}.end_with?(#{@stub_file.separator})"       
  end

  test "dir does not have doubled separator" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    doubled_separator = @stub_file.separator * 2
    assert_equal 0, kata.dir.scan(doubled_separator).length    
  end
  
  test "dir is based on root_dir and id" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert kata.dir.match(root_dir), "root_dir"
    id = Uuid.new(info[:id])
    assert kata.dir.match(id.inner), "id.inner"
    assert kata.dir.match(id.outer), "id.outer"
  end
  
  test "created is from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal Time.mktime(*info[:created]), kata.created    
  end
  
  test "age_in_seconds is set from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    now = info[:created]
    seconds = 5
    now = now[0...-1] + [now.last + seconds ]
    assert_equal seconds, kata.age_in_seconds(Time.mktime(*now))    
  end
  
  test "language is set from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal Language.new(root_dir, info[:language]).name, kata.language.name
  end
  
  test "exercise is set from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal Exercise.new(root_dir, info[:exercise]).name, kata.exercise.name    
  end
  
  test "creating a new kata succeeds and creates katas root dir" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_not_equal nil, @stub_file.write_log[kata.dir]    
  end
  
  test "Kata.exists? returns false before kata is created and true after kata is created" do
    info = @stub_file.kata_manifest
    id = info[:id]
    assert !Kata.exists?(root_dir, id), "exists? false before created"
    Kata.create(root_dir, info)
    assert Kata.exists?(root_dir, id), "exists? true after created"
  end
  
  test "you can create an avatar in a kata" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    assert avatar_name, avatar.name
  end
  
  test "multiple avatars in a kata are all seen" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    Avatar.create(kata, 'lion')
    Avatar.create(kata, 'hippo')
    avatars = kata.avatars
    assert_equal 2, avatars.length
    assert_equal ['hippo','lion'], avatars.collect{|avatar| avatar.name}.sort
  end
  
end
