#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../cyberdojo_test_base'
require 'TdGapper'

class TdGapperTests < CyberDojoTestBase

  test "number" do
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

    assert_equal 0, gapper.number({ 'time' => [year,month,day,hour,30,19] })
    assert_equal 1, gapper.number({ 'time' => [year,month,day,hour,30,22] })
    assert_equal 2, gapper.number({ 'time' => [year,month,day,hour,30,58] })
    assert_equal 3, gapper.number({ 'time' => [year,month,day,hour,31,11] })
  end

  test "stats" do
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
      'hippo' => [ t1={ 'time' => [year,month,day,hour,30,21] }, # 1
                   t2={ 'time' => [year,month,day,hour,31,33] }, # 4
                 ],
      'lion' =>  [ t3={ 'time' => [year,month,day,hour,30,25] }, # 1
                   t4={ 'time' => [year,month,day,hour,31,37] }, # 4
                   t5={ 'time' => [year,month,day,hour,31,39] }, # 4
                 ],
      'panda' => [ t6={ 'time' => [year,month,day,hour,31,42] }, # 5
                 ]
    }
    expected =
    {
      'avatars' =>
      {
        'hippo' => { 1 => [ t1 ], 4 => [ t2    ] },
        'lion'  => { 1 => [ t3 ], 4 => [ t4,t5 ] },
        'panda' => {                             5 => [ t6 ] }
      },
      'td_nos' => [0,1,4,5,7]
    }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)

    assert_equal expected, gapper.stats(all_incs, now)
  end

  test "vertical bleed" do
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    now = [year,month,day,hour,32,23] #td 7
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    all_incs =
    {
      'hippo' => [ t1={ 'time' => [year,month,day,hour,30,21] }, # 1
                   t2={ 'time' => [year,month,day,hour,31,33] }, # 4
                 ],
      'lion' =>  [ t3={ 'time' => [year,month,day,hour,30,25] }, # 1
                   t4={ 'time' => [year,month,day,hour,31,37] }, # 4
                   t5={ 'time' => [year,month,day,hour,31,39] }, # 4
                 ],
      'panda' => [ t6={ 'time' => [year,month,day,hour,31,42] }, # 5
                 ]
    }
    expected =
    {
      'hippo' => { 0 => [ ], 1 => [ t1 ], 4 => [ t2    ], 5 => [    ], 7 => [ ] },
      'lion'  => { 0 => [ ], 1 => [ t3 ], 4 => [ t4,t5 ], 5 => [    ], 7 => [ ] },
      'panda' => { 0 => [ ], 1 => [    ], 4 => [       ], 5 => [ t6 ], 7 => [ ] }
    }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)
    s = gapper.stats(all_incs, now)
    gapper.vertical_bleed(s)
    assert_equal expected, s['avatars']
  end

  test "collapsed table" do
    # 30 mins = 30 x 3 x 20 secs = 90 tds
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20

    td_nos = [0,1,4,5]
    expected =
    {
      0 => [ 'dont_collapse', 0 ],
      1 => [ 'dont_collapse', 2 ],
      4 => [ 'dont_collapse', 0 ]
    }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)

    actual = gapper.collapsed_table(td_nos)
    assert_equal expected, actual

    td_nos = [0,1,3,95]
    expected =
    {
      0 => [ 'dont_collapse', 0 ],
      1 => [ 'dont_collapse', 1 ],
      3 => [ 'collapse', 91 ]
    }
    actual = gapper.collapsed_table(td_nos)
    assert_equal expected, actual
  end

  test "fully gapped no traffic_lights yet" do
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    now = [year,month,day+1,hour,32,23] #td 4327
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    all_incs = { }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)
    actual = gapper.fully_gapped(all_incs, now)
    expected = { }
    assert_equal expected, actual
  end

  test "fully gapped" do
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    now = [year,month,day+1,hour,32,23] #td 4327
    max_seconds_uncollapsed = 30 * 60
    seconds_per_td = 20
    all_incs =
    {
      'hippo' => [ t1={ 'time' => [year,month,day,hour,30,21] }, # 1
                   t2={ 'time' => [year,month,day,hour,31,33] }, # 4
                 ],
      'lion' =>  [ t3={ 'time' => [year,month,day,hour,30,25] }, # 1
                   t4={ 'time' => [year,month,day,hour,31,37] }, # 4
                   t5={ 'time' => [year,month,day,hour,31,39] }, # 4
                 ],
      'panda' => [ t6={ 'time' => [year,month,day,hour,31,42] }, # 5
                 ]
    }
    expected =
    {
      'hippo' => { 0 => [ ], 1 => [ t1 ], 2 => [ ], 3 => [ ], 4 => [ t2    ], 5 => [    ], 6 => { 'collapsed' => 4321 }, 4327 => [ ] },
      'lion'  => { 0 => [ ], 1 => [ t3 ], 2 => [ ], 3 => [ ], 4 => [ t4,t5 ], 5 => [    ], 6 => { 'collapsed' => 4321 }, 4327 => [ ] },
      'panda' => { 0 => [ ], 1 => [    ], 2 => [ ], 3 => [ ], 4 => [       ], 5 => [ t6 ], 6 => { 'collapsed' => 4321 }, 4327 => [ ] }
    }
    gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)
    actual = gapper.fully_gapped(all_incs, now)
    assert_equal expected, actual
  end

end
