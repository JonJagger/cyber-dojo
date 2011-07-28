require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/td_gapper_tests.rb

class TdGapperTests < ActionController::TestCase

  def test_number
    year = 2011; month = 5; day = 18; hour = 2;    
    start = Time.mktime(*[year,month,day,hour,30,0])
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    # 0 : 2:30:00 - 2:30:20
    # 1 : 2:30:20 - 2:30:40
    # 2 : 2:30:40 - 2:31:00
    # 3 : 2:31:00 - 2:31:20
    # 4 : 2:31:20 - 2:31:40
    # 5 : 2:31:40 - 2:32:00    
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)

    assert_equal 0, gapper.number({ :time => [year,month,day,hour,30,19] })
    assert_equal 1, gapper.number({ :time => [year,month,day,hour,30,22] })
    assert_equal 2, gapper.number({ :time => [year,month,day,hour,30,58] })
    assert_equal 3, gapper.number({ :time => [year,month,day,hour,31,11] })    
  end

  def test_stats
    year = 2011; month = 5; day = 18; hour = 2;    
    start = Time.mktime(*[year,month,day,hour,30,0])
    now = [year,month,day,hour,32,23] #td 7
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20    

    # 0 : 2:30:00 - 2:30:20
    # 1 : 2:30:20 - 2:30:40
    # 2 : 2:30:40 - 2:31:00
    # 3 : 2:31:00 - 2:31:20
    # 4 : 2:31:20 - 2:31:40
    # 5 : 2:31:40 - 2:32:00    
    # 6 : 2;32;00 - 2:32:20
    # 7 : 2;32:20 - 2:32:40

    all_incs =
    {
      :hippo => [ t1={ :time => [year,month,day,hour,30,21] }, # 1
                  t2={ :time => [year,month,day,hour,31,33] }, # 4
                ],
      :lion =>  [ t3={ :time => [year,month,day,hour,30,25] }, # 1
                  t4={ :time => [year,month,day,hour,31,37] }, # 4
                  t5={ :time => [year,month,day,hour,31,39] }, # 4
                ],
      :panda => [ t6={ :time => [year,month,day,hour,31,42] }, # 5
                ]
    }
    expected = 
    {
      :avatars =>
      {
        :hippo => { 1 => [ t1 ], 4 => [ t2 ] },
        :lion  => { 1 => [ t3 ], 4 => [ t4,t5 ] },
        :panda => { 5 => [ t6 ] }
      },
      :td_nos => [0,1,4,5,7]
    }    
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)

    assert_equal expected, gapper.stats(all_incs, now)
  end

  def test_vertical_bleed
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    now = [year,month,day,hour,32,23] #td 7
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    all_incs =
    {
      :hippo => [ t1={ :time => [year,month,day,hour,30,21] }, # 1
                  t2={ :time => [year,month,day,hour,31,33] }, # 4
                ],
      :lion =>  [ t3={ :time => [year,month,day,hour,30,25] }, # 1
                  t4={ :time => [year,month,day,hour,31,37] }, # 4
                  t5={ :time => [year,month,day,hour,31,39] }, # 4
                ],
      :panda => [ t6={ :time => [year,month,day,hour,31,42] }, # 5
                ]
    }
    expected = 
    {
      :hippo => { 0 => [], 1 => [ t1 ], 4 => [ t2 ],    5 => [],     7 => [] },
      :lion  => { 0 => [], 1 => [ t3 ], 4 => [ t4,t5 ], 5 => [],     7 => [] },
      :panda => { 0 => [], 1 => [],     4 => [],        5 => [ t6 ], 7 => [] }
    }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)
    s = gapper.stats(all_incs, now)
    gapper.vertical_bleed(s)
    assert_equal expected, s[:avatars]
  end

  def test_collapsed_table
    # 30 mins = 30 x 3 x 20 secs = 90 tds
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    
    td_nos = [0,1,4,5]
    expected =
    {
      0 => [ :tds, 0 ],
      1 => [ :tds, 2 ], 
      4 => [ :tds, 0 ]
    }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)

    actual = gapper.collapsed_table(td_nos)
    assert_equal expected, actual
    
    td_nos = [0,1,3,95]
    expected =
    {
      0 => [ :tds, 0 ],
      1 => [ :tds, 1 ],
      3 => [ :collapsed, 91 ] 
    }
    actual = gapper.collapsed_table(td_nos)
    assert_equal expected, actual
  end

  def test_fully_gapped_no_increments_yet
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    now = [year,month,day+1,hour,32,23] #td 4327
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    all_incs = {}
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)
    actual = gapper.fully_gapped(all_incs, now)
    expected = {}
    assert_equal expected, actual    
  end
  
  def test_fully_gapped
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    now = [year,month,day+1,hour,32,23] #td 4327
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    all_incs =
    {
      :hippo => [ t1={ :time => [year,month,day,hour,30,21] }, # 1
                  t2={ :time => [year,month,day,hour,31,33] }, # 4
                ],
      :lion =>  [ t3={ :time => [year,month,day,hour,30,25] }, # 1
                  t4={ :time => [year,month,day,hour,31,37] }, # 4
                  t5={ :time => [year,month,day,hour,31,39] }, # 4
                ],
      :panda => [ t6={ :time => [year,month,day,hour,31,42] }, # 5
                ]
    }
    expected = 
    {
      :hippo => { 0 => [], 1 => [ t1 ], 2 => [], 3 => [], 4 => [ t2 ],    5 => [],     6 => { :collapsed => 4321}, 4327 => [] },
      :lion  => { 0 => [], 1 => [ t3 ], 2 => [], 3 => [], 4 => [ t4,t5 ], 5 => [],     6 => { :collapsed => 4321}, 4327 => [] },
      :panda => { 0 => [], 1 => [],     2 => [], 3 => [], 4 => [],        5 => [ t6 ], 6 => { :collapsed => 4321}, 4327 => [] }
    }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)
    actual = gapper.fully_gapped(all_incs, now)
    assert_equal expected, actual
  end
  
end

# collapsed_table
# ---------------
# Suppose I have :hippo with lights for td's numbered 5 and 15 
# and that the time this gap (from 5 to 15, viz 9 td's) represents 
# is large enough to be collapsed. 
# Does this mean the hippo's tr gets 10 empty td's between the 
# td#5 and the td#15? 
# The answer is it depends on the other avatars. 
# The td's have to align vertically. 
# For example if the :lion has a td at 11 then
# this effectively means that for the hippo its 5-15 has to be
# considered as 5-11-15 and the gaps are really 5-11 (5 td gaps)
# and 11-15 (3 td gaps).
# This is where the :td_nos array comes in. 
# It is an array of all td numbers for a dojo across all avatars.
# Suppose the :td_nos array is [1,5,11,13,15,16,18,23]
# This means that the hippo has to treat its 5-15 gap as 5-11-13-15
# so the gaps are really 5-11 (5 td gaps), 11-13 (1 td gap) and 13-15
# (1 td gap). Note that the :hippo doesn't have a light at either 13 or 15
# but that doesn't matter, we can't collapse "across" or "through" these.
# This is because I need vertical consistency.

# Now, suppose a dojo runs over two days, there would be a long
# period of time at night when no traffic lights would get added. Thus
# the :td_nos array is likely to have large gaps, 
# eg [....450,2236,2237,...]
# at 20 seconds per gap the difference between 450 and 2236 is 1786
# and 1786*20 == 35,720 seconds == 9 hours 55 mins 20 secs.
# We would not want this displayed at 1786 empty td's because it would
# ensure all lights would vanish off the left of the display. Remember
# there is a maximum number of td's displayed in a tr (to avoid a scrollbar
# because the page auto refreshes).
# Thus there is a max_seconds_uncollapsed parameter. If the time difference
# between two consecutive entries in the :td_nos array is greater than
# max_seconds_uncollapsed the the display will not show one td for each
# gap but will collapse the entire gap down to one td.
# A collapsed td is shown with a ... in it.


