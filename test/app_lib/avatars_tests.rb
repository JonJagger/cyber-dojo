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

  #test "dojo.katas[id].avatars" do
  #  avatars = @dojo.katas[@id].avatars.map{|avatar| avatar.name}
  #  assert avatars.include? 'alligator'
  #  assert avatars.include? 'buffalo'
  #  assert avatars.include? 'cheetah'
  #end

  #test "dojo.katas[id].avatars[alligator]" do
  #  avatar = @dojo.katas[@id].avatars['alligator']
  #  assert_equal 'alligator', avatar.name
  #end

  #test "dojo.katas[id].start_avatar" do
  #  @kata = @dojo.make_kata(@language,@exercise)
  #  avatar = @kata.start_avatar
  #  puts avatar.name
  #end

end
