require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../app_models/spy_disk'

class KatasTests < ActionController::TestCase

  def setup
    @disk = SpyDisk.new
    paas = ExposedLinux::Paas.new(@disk)
    @dojo = paas.create_dojo(root_path + '../../','rb')
  end

  def teardown
    @disk.teardown
  end

  test "dojo.katas.each forwards to katas_each on paas" do
    katas = @dojo.katas.map {|kata| kata.id}
    assert katas.size > 100
    assert katas.all?{|id| id.length == 10}
  end

  test "dojo.katas[id]" do
    kata = @dojo.katas["ABCDE12345"]
    assert_equal ExposedLinux::Kata, kata.class
    assert_equal "ABCDE12345", kata.id
  end

  test "dojo.katas[id].start_avatar" do
    kata = @dojo.katas["ABCDE12345"]
    avatar = kata.start_avatar
    assert_equal ExposedLinux::Avatar, avatar.class
    assert_equal 'lion', avatar.name
  end

end
