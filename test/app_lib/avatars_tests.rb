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
  end

  test "kata.avatars" do
    kata = @dojo.make_kata(@language,@exercise)
    avatar1 = kata.start_avatar
    avatar2 = kata.start_avatar
    expected_names = [avatar1.name, avatar2.name]
    names = kata.avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  test "dojo.katas[id].avatars" do
    kata = @dojo.make_kata(@language,@exercise)
    avatar1 = kata.start_avatar
    avatar2 = kata.start_avatar
    expected_names = [avatar1.name, avatar2.name]
    names = @dojo.katas[kata.id].avatars.map{|avatar| avatar.name}
    assert_equal expected_names.sort, names.sort
  end

  test "dojo.katas[id].avatars[name]" do
    kata = @dojo.make_kata(@language,@exercise)
    avatar = kata.start_avatar
    name = avatar.name
    names = kata.avatars.map{|avatar| avatar.name}
    assert_equal [name], names
    avatar = @dojo.katas[kata.id].avatars[name]
    assert_equal name, avatar.name
  end

  test "avatar.save_and_run" do
    kata = @dojo.make_kata(@language,@exercise)
    avatar = kata.start_avatar
    #....


  end

end
