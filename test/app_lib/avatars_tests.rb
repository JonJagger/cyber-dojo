require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../../lib/disk'
require File.dirname(__FILE__) + '/../../lib/git'
require File.dirname(__FILE__) + '/../../lib/runner'

class AvatarTests < ActionController::TestCase

  def setup
    @disk = Disk.new
    @git = Git.new
    @runner = Runner.new
    @paas = ExposedLinux::Paas.new(@disk,@git,@runner)
    @format = 'json'
    @dojo = @paas.create_dojo(root_path,@format)
    @language = @dojo.languages['Java-JUnit']
    @exercise = @dojo.exercises['Yahtzee']
    `rm -rf #{@paas.path(@dojo.katas)}`
    @kata = @dojo.make_kata(@language,@exercise)
  end

  test "kata.avatars() returns all avatars started in the kata" do
    avatar1 = @kata.start_avatar
    avatar2 = @kata.start_avatar
    expected_names = [avatar1.name, avatar2.name]
    names = @kata.avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  test "dojo.katas[id].avatars() returns all avatars started in kata with given id" do
    avatar1 = @kata.start_avatar
    avatar2 = @kata.start_avatar
    expected_names = [avatar1.name, avatar2.name]
    names = @dojo.katas[@kata.id].avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  test "dojo.katas[id].avatars[name] finds avatar with given name" do
    avatar = @kata.start_avatar
    name = avatar.name
    names = @kata.avatars.map{|avatar| avatar.name}
    assert_equal [name], names
    avatar = @dojo.katas[@kata.id].avatars[name]
    assert_equal name, avatar.name
  end

  test "avatar.test() initial output" do
    avatar = @kata.start_avatar
    output = avatar.test()
    assert output.include?('java.lang.AssertionError: expected:<54> but was:<42>')
  end

  test "avatar.save_() then avatar.test()" do
    avatar = @kata.start_avatar
    #avatar.save(delta,visible_files)
    #output = avatar.test()
  end

end
