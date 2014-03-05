require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'

class AvatarTests < ActionController::TestCase

  def setup
    paas = ExposedLinux::Paas.new
    @id = 'FCF27D87F1'
    @dojo = paas.create_dojo(root_path + '../../','rb')
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

end
