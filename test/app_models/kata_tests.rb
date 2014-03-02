require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'
require File.dirname(__FILE__) + '/stub_git'
require File.dirname(__FILE__) + '/stub_runner'

class KataTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    Thread.current[:git] = @git = StubGit.new
    Thread.current[:runner] = StubRunner.new
    @id = '45ED23A2F1'
  end

  def teardown
    @disk.teardown
    Thread.current[:disk] = nil
    Thread.current[:git] = nil
    Thread.current[:runner] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no disk on thread ctor raises" do
    Thread.current[:disk] = nil
    error = assert_raises(RuntimeError) { Kata.new(nil,nil) }
    assert_equal 'no disk', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "id is from ctor" do
    id_is_from_ctor_test('rb')
    id_is_from_ctor_test('json')
  end

  def id_is_from_ctor_test(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    assert_equal @id, @kata.id
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path ends in slash" do
    path_ends_in_slash_test('rb')
    path_ends_in_slash_test('json')
  end

  def path_ends_in_slash_test(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    assert @kata.path.end_with?(@disk.dir_separator)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path does not have doubled separator" do
    path_does_not_have_doubled_separator_test('rb')
    path_does_not_have_doubled_separator_test('json')
  end

  def path_does_not_have_doubled_separator_test(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    doubled_separator = @disk.dir_separator * 2
    assert_equal 0, @kata.path.scan(doubled_separator).length
  end
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path is based on cyberdojo root_dir and id" do
    path_is_based_on_cyberdojo_root_dir_and_id_test('rb')
    path_is_based_on_cyberdojo_root_dir_and_id_test('json')
  end

  def path_is_based_on_cyberdojo_root_dir_and_id_test(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    assert @kata.path.match(@dojo.path), 'root_dir'
    uuid = Uuid.new(@id)
    assert @kata.path.match(uuid.inner), 'id.inner'
    assert @kata.path.match(uuid.outer), 'id.outer'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? false when dir does not exist, true when dir does exist" do
    exists_false_when_dir_does_not_exist_true_when_dir_does_exist_test('rb')
    teardown
    setup
    exists_false_when_dir_does_not_exist_true_when_dir_does_exist_test('json')
  end

  def exists_false_when_dir_does_not_exist_true_when_dir_does_exist_test(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    assert !@kata.exists?, '!@kata.exists?'
    @kata.dir.make
    assert @kata.exists?, '@kata.exists?'
  end
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "create_kata saves manifest in kata dir (rb)" do
    @dojo = Dojo.new('spied/', 'rb')
    manifest = { :id => @id }
    @kata = @dojo.create_kata(manifest)
    assert @kata.dir.log.include? [ 'write', 'manifest.rb', manifest.inspect ]
  end

  test "create_kata saves manifest in kata dir (json)" do
    @dojo = Dojo.new('spied/', 'json')
    manifest = { :id => @id }
    @kata = @dojo.create_kata(manifest)
    assert @kata.dir.log.include? [ 'write', 'manifest.json', JSON.unparse(manifest) ]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "created date is read from manifest" do
    created_date_test('rb')
    created_date_test('json')
  end

  def created_date_test(format)
    now = [2013,6,29,14,24,51]
    manifest = {
      :created => now,
      :id => @id
    }
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    @kata = @dojo.create_kata(manifest)
    assert_equal Time.mktime(*now), @kata.created
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "age_in_seconds is calculated from creation date in manifest" do
    age_in_seconds_test('rb')
    age_in_seconds_test('json')
  end

  def age_in_seconds_test(format)
    now = [2013,6,29,14,24,51]
    manifest = {
      :created => now,
      :id => @id
    }
    seconds = 5
    @dojo = Dojo.new('spied/',format)
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    @kata = @dojo.create_kata(manifest)
    now[-1] += seconds
    assert_equal seconds, @kata.age_in_seconds(Time.mktime(*now))
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "language name is read from manifest" do
    language_name_is_read_from_manifest_test('rb')
    language_name_is_read_from_manifest_test('json')
  end

  def language_name_is_read_from_manifest_test(format)
    language = 'Wibble'
    manifest = {
      :language => language,
      :id => @id
    }
    @dojo = Dojo.new('spied/',format)
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    @kata = @dojo.create_kata(manifest)
    assert_equal language, @kata.language.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exercise name is read from manifest" do
    exercise_name_is_read_from_manifest_test('rb')
    exercise_name_is_read_from_manifest_test('json')
  end

  def exercise_name_is_read_from_manifest_test(format)
    exercise = 'Tweedle'
    manifest = {
      :exercise => exercise,
      :id => @id
    }
    @dojo = Dojo.new('spied/',format)
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    @kata = @dojo.create_kata(manifest)
    assert_equal exercise, @kata.exercise.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "visible_files are read from manifest" do
    visible_files_are_read_from_manifest_test('rb')
    visible_files_are_read_from_manifest_test('json')
  end

  def visible_files_are_read_from_manifest_test(format)
    visible_files = {
        'wibble.h' => '#include <stdio.h>',
        'wibble.c' => '#include "wibble.h"'
    }
    manifest = {
      :id => @id,
      :visible_files => visible_files
    }
    @dojo = Dojo.new('spied/',format)
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    @kata = @dojo.create_kata(manifest)
    assert_equal visible_files, @kata.visible_files
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? returns false before kata is created then true after kata is created" do
    exists_returns_false_before_kata_is_created_then_true_after_kata_is_created('rb')
    teardown
    setup
    exists_returns_false_before_kata_is_created_then_true_after_kata_is_created('json')
  end

  def exists_returns_false_before_kata_is_created_then_true_after_kata_is_created(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    assert !@kata.exists?, '!kata.exists? before created'
    manifest = { :id => @id }
    @kata = @dojo.create_kata(manifest)
    assert @kata.exists?, 'Kata.exists? after created'
    kata_manifest_spy_write(format,manifest)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "kata['lion'] exists when its dir exists" do
    kata_lion_exists_when_its_dir_exists('rb')
    teardown
    setup
    kata_lion_exists_when_its_dir_exists('json')
  end

  def kata_lion_exists_when_its_dir_exists(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    avatar = @kata['lion']
    assert !avatar.exists?, '!avatar.exists?'
    avatar.dir.make
    assert avatar.exists?, 'avatar.exists?'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "you can create an avatar in a kata" do
    you_can_create_an_avatar_in_a_kata('rb')
    you_can_create_an_avatar_in_a_kata('json')
  end

  def you_can_create_an_avatar_in_a_kata(format)
    @dojo = Dojo.new('spied/', format)
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name
    }
    @kata = @dojo.create_kata(manifest)
    assert 'hippo', @kata['hippo'].name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "multiple avatars in a kata are all seen" do
    multiple_avatars_in_a_kata_are_all_seen('rb')
    teardown
    setup
    multiple_avatars_in_a_kata_are_all_seen('json')
  end

  def multiple_avatars_in_a_kata_are_all_seen(format)
    @dojo = Dojo.new('spied/', format)
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => {
        'name' => 'content for name'
      },
      :language => language.name
    }
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
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
    start_avatar_succeeds_once_for_each_avatar_then_fails('rb')
    teardown
    setup
    start_avatar_succeeds_once_for_each_avatar_then_fails('json')
  end

  def start_avatar_succeeds_once_for_each_avatar_then_fails(format)
    @dojo = Dojo.new('spied/', format)
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name,
      :visible_files => {
        'wibble.h' => '#include <stdio.h>'
      }
    }
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
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

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_manifest_spy_read(format, spied)
    if (format == 'rb')
      @kata.dir.spy_read('manifest.rb', spied.inspect)
    end
    if (format == 'json')
      @kata.dir.spy_read('manifest.json', JSON.unparse(spied))
    end
  end

  def kata_manifest_spy_write(format, spied)
    if (format == 'rb')
      @kata.dir.spy_write('manifest.rb', spied.inspect)
    end
    if (format == 'json')
      @kata.dir.spy_write('manifest.json', JSON.unparse(spied))
    end
  end

end
