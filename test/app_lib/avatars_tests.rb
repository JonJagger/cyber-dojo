require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../app_models/spy_disk'

class AvatarTests < ActionController::TestCase

  def setup
    @disk = SpyDisk.new
    @paas = ExposedLinux::Paas.new(@disk)
    @id = 'FCF27D87F1'
    @dojo = @paas.create_dojo(root_path + '../../','rb')
  end

  def teardown
    @disk.teardown
  end

  test "dojo.katas[id].avatars" do
    avatars = @dojo.katas[@id].avatars.map{|avatar| avatar.name}
    assert avatars.include? 'alligator'
    assert avatars.include? 'buffalo'
    assert avatars.include? 'cheetah'
  end

  test "dojo.katas[id].avatars[alligator]" do
    avatar = @dojo.katas[@id].avatars['alligator']
    assert_equal 'alligator', avatar.name
  end

  test "dojo.katas[id].start_avatar" do

  end

end
