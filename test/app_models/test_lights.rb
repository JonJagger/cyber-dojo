#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class LightsTests < ModelTestCase

  test "lights initially empty" do
    json_and_rb do
      kata = make_kata
      lights = kata.start_avatar.lights
      assert_equal [], lights.entries
      assert_equal 0, lights.length
    end
  end

end
