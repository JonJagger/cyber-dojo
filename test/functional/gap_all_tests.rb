require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/gap_all_tests.rb

class GapAllTests < ActionController::TestCase

  def test_gap_all
    all_incs =
    {
      :hippo => [ a={ :time => [2011,5,18,9,50,24] },
                  b={ :time => [2011,5,18,9,50,27] },
                ],
      :lion =>  [ c={ :time => [2011,5,18,9,50,25] },
                  d={ :time => [2011,5,18,9,50,40] },
                ],
      :panda => [ e={ :time => [2011,5,18,9,50,39] },
                ]
    }
    created = Time.mktime(*[2011,5,18,9,50,23])
    now = Time.mktime(*d[:time])
    seconds_per_gap = 5
    actual_time_gaps = time_gaps(created, now, seconds_per_gap)
    expected_time_gaps = 
    [
      created + 0*seconds_per_gap,
      created + 1*seconds_per_gap,
      created + 2*seconds_per_gap,
      created + 3*seconds_per_gap,
      created + 4*seconds_per_gap,
    ]
    assert_equal expected_time_gaps, actual_time_gaps

    expected_gaps = {
      :hippo => [
        [a,b], # [50:23 -> 50:28] # 0-5 
        [],    # [50:28 -> 50:33] # 5-10 
        [],    # [50:33 -> 50:38] # 10-15 
        [],    # [50:38 -> 50:43] # 15-20 
      ],
      :lion => [
        [c],
        [],
        [],
        [d],
      ],
      :panda => [
        [],
        [],
        [],
        [e],
      ]    
    }

    actual_gaps = gap_all(all_incs, created, now, seconds_per_gap)
    assert_equal expected_gaps, actual_gaps
  end

end
