require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'
require File.dirname(__FILE__) + '/stub_git'

class KataTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    Thread.current[:git] = @git = StubGit.new
    @dojo = Dojo.new('spied')
    @id = '45ED23A2F1'
    @kata = @dojo[@id]
  end

  def teardown
    Thread.current[:disk] = nil
    Thread.current[:git] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if no disk on thread ctor raises" do
    Thread.current[:disk] = nil
    error = assert_raises(RuntimeError) { Kata.new(nil,nil) }
    assert_equal "no disk", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "id is from ctor" do
    assert_equal @id, @kata.id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? false when dir does not exist, true when dir does exist" do
    assert !@kata.exists?, "!@kata.exists?"
    @kata.dir.make
    assert @kata.exists?, "@kata.exists?"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path does not end in slash" do
    assert !@kata.path.end_with?(@disk.dir_separator)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path does not have doubled separator" do
    doubled_separator = @disk.dir_separator * 2
    assert_equal 0, @kata.path.scan(doubled_separator).length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path is based on cyberdojo root_dir and id" do
    assert @kata.path.match(@dojo.path), "root_dir"
    uuid = Uuid.new(@id)
    assert @kata.path.match(uuid.inner), "id.inner"
    assert @kata.path.match(uuid.outer), "id.outer"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "creation saves manifest in kata dir" do
    manifest = { :id => @id }
    kata = @dojo.create_kata(manifest)
    assert_equal [ [ 'manifest.rb', manifest.inspect ] ], @kata.dir.write_log
    assert_equal [ ], @kata.dir.read_log
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "created date is read from manifest" do
    now = [2013,6,29,14,24,51]
    manifest = {
      :created => now,
      :id => @id
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    assert_equal Time.mktime(*now), @kata.created
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "age_in_seconds is calculated from creation date in manifest" do
    now = [2013,6,29,14,24,51]
    manifest = {
      :created => now,
      :id => @id
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    seconds = 5
    now = now[0...-1] + [now.last + seconds ]
    assert_equal seconds, @kata.age_in_seconds(Time.mktime(*now))
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "language name is read from manifest" do
    language = 'Wibble'
    manifest = {
      :language => language,
      :id => @id
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    assert_equal language, @kata.language.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exercise name is read from manifest" do
    exercise = 'Tweedle'
    manifest = {
      :exercise => exercise,
      :id => @id
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    assert_equal exercise, @kata.exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "visible_files are read from manifest" do
    visible_files = {
        'wibble.h' => '#include <stdio.h>',
        'wibble.c' => '#include "wibble.h"'
    }
    manifest = {
      :id => @id,
      :visible_files => visible_files
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    assert_equal visible_files, @kata.visible_files
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "Kata.exists? returns false before kata is created then true after kata is created" do
    assert !@kata.exists?, "!kata.exists? before created"
    manifest = { :id => @id }
    @dojo.create_kata(manifest)
    assert @kata.exists?, "Kata.exists? after created"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "kata['lion'] exists when its dir exists" do
    avatar = @kata['lion']
    assert !avatar.exists?, "!avatar.exists?"
    avatar.dir.make
    assert avatar.exists?, "avatar.exists?"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "you can create an avatar in a kata" do
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    assert 'hippo', kata['hippo'].name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "multiple avatars in a kata are all seen" do
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => {
        'name' => 'content for name'
      },
      :language => language.name
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    animal1 = kata.start_avatar
    animal2 = kata.start_avatar
    avatars = kata.avatars
    assert_equal 2, avatars.length
    assert_equal [animal1.name,animal2.name].sort, avatars.collect{|avatar| avatar.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "start_avatar succeeds once for each avatar name then fails" do
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name,
      :visible_files => {
        'wibble.h' => '#include <stdio.h>'
      }
    }
    @kata.dir.spy_read('manifest.rb', manifest.inspect)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    created = [ ]
    Avatar.names.length.times do |n|
      avatar = kata.start_avatar
      assert_not_nil avatar
      created << avatar
    end
    assert_equal Avatar.names.length, created.collect{|avatar| avatar.name}.uniq.length
    avatar = kata.start_avatar
    assert_nil avatar
  end

end
