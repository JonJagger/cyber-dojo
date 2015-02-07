#!/usr/bin/env ruby

require_relative 'app_helpers_test_base'

class ToolTipTests < AppHelpersTestBase

  include TipHelper

  test 'tool tip' do
    #kata = nil
    #avatar = Avatar.new(kata,'hippo')
    #light = Light.new(avatar, {
    #  'number' => 2,
    #  'time' => [2012,5,1,23,20,45],
    #  'colour' => 'red'
    #})
    id = 'unused'
    avatarName = 'hippo'
    wasTag = '1'
    nowTag = '2'
    actual = traffic_light_tip(id,avatarName,wasTag,nowTag)
    assert_equal "Click to review hippo&#39;s 1 &harr; 2 diff", actual
  end

end
