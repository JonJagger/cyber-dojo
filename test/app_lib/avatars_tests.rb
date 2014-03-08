require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../../lib/disk'
require File.dirname(__FILE__) + '/../../lib/git'

class AvatarTests < ActionController::TestCase

  def setup
    @disk = Disk.new
    @git = Git.new
    @paas = ExposedLinux::Paas.new(@disk,@git)
    @format = 'json'
    @dojo = @paas.create_dojo(root_path,@format)
    @language = @dojo.languages['Java-JUnit']
    @exercise = @dojo.exercises['Yahtzee']
    `rm -rf #{@paas.path(@dojo.katas)}`
  end

  test "dojo.katas[id].avatars" do
    kata = @dojo.make_kata(@language,@exercise)
    avatar = kata.start_avatar
    avatar = kata.start_avatar
    avatars = @dojo.katas[kata.id].avatars.map{|avatar| avatar.name}
    assert_equal 2, avatars.length
  end

  test "dojo.katas[id].avatars[name]" do
    kata = @dojo.make_kata(@language,@exercise)
    name = kata.start_avatar.name
    avatar = @dojo.katas[kata.id].avatars[name]
    assert_equal name, avatar.name
  end


end
