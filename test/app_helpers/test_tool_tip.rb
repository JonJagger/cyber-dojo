#!/usr/bin/env ruby

require_relative 'app_helpers_test_base'

class ToolTipTests < AppHelpersTestBase

  include TipHelper

  test 'tool tip' do
    kata = nil
    avatar = Avatar.new(kata,'hippo')
    was_tag = 1
    now_tag = 2

    # TODO: this test now requires a fake disk
    #actual = traffic_light_tip(id,avatar,was_tag,now_tag)
    #assert_equal "Click to review hippo&#39;s 1 &harr; 2 diff", actual
  end

end
