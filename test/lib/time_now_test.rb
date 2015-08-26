#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'

class TimeNowTests < LibTestBase

  class FakeTime
    def year; 1966; end
    def month; 11; end
    def day; 23; end
    def hour; 8; end
    def min; 45; end
    def sec; 59; end
  end

  test 'time_now' do
    expected = [1966,11,23,8,45,59]
    assert_equal expected, time_now(FakeTime.new)
  end

private

  include TimeNow

end
