#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class TdGapperTests < AppLibTestBase

  def setup
    super
    @gapper = TdGapper.new(start, seconds_per_td, max_seconds_uncollapsed)    
  end

  attr_reader :gapper
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'number' do
    # 0 : 2:30:00 - 2:30:20
    # 1 : 2:30:20 - 2:30:40
    # 2 : 2:30:40 - 2:31:00
    # 3 : 2:31:00 - 2:31:20
    # 4 : 2:31:20 - 2:31:40
    # 5 : 2:31:40 - 2:32:00

    assert_equal 0, gapper.number(make_light(30,19))
    assert_equal 1, gapper.number(make_light(30,22))
    assert_equal 2, gapper.number(make_light(30,58))
    assert_equal 3, gapper.number(make_light(31,11))
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'stats' do
    # 0 : 2:30:00 - 2:30:20
    # 1 : 2:30:20 - 2:30:40
    # 2 : 2:30:40 - 2:31:00
    # 3 : 2:31:00 - 2:31:20
    # 4 : 2:31:20 - 2:31:40
    # 5 : 2:31:40 - 2:32:00
    # 6 : 2;32;00 - 2:32:20
    # 7 : 2;32:20 - 2:32:40

    all_lights =
    {
      'hippo' => [ t1=make_light(30,21), # 1
                   t2=make_light(31,33), # 4
                 ],
      'lion' =>  [ t3=make_light(30,25), # 1
                   t4=make_light(31,37), # 4
                   t5=make_light(31,39), # 4
                 ],
      'panda' => [ t6=make_light(31,42), # 5
                 ]
    }
    expected =
    {
      :avatars =>
      {
        'hippo' => { 1 => [ t1 ], 4 => [ t2    ] },
        'lion'  => { 1 => [ t3 ], 4 => [ t4,t5 ] },
        'panda' => {                             5 => [ t6 ] }
      },
      :td_nos => [0,1,4,5,7]
    }
    now = [year,month,day,hour,32,23] #td 7
    assert_equal expected, gapper.stats(all_lights, now)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'vertical bleed' do
    all_lights =
    {
      'hippo' => [ t1=make_light(30,21), # 1
                   t2=make_light(31,33), # 4
                 ],
      'lion' =>  [ t3=make_light(30,25), # 1
                   t4=make_light(31,37), # 4
                   t5=make_light(31,39), # 4
                 ],
      'panda' => [ t6=make_light(31,42), # 5
                 ]
    }
    expected =
    {
      'hippo' => { 0 => [ ], 1 => [ t1 ], 4 => [ t2    ], 5 => [    ], 7 => [ ] },
      'lion'  => { 0 => [ ], 1 => [ t3 ], 4 => [ t4,t5 ], 5 => [    ], 7 => [ ] },
      'panda' => { 0 => [ ], 1 => [    ], 4 => [       ], 5 => [ t6 ], 7 => [ ] }
    }
    now = [year,month,day,hour,32,23] #td 7
    s = gapper.stats(all_lights, now)
    gapper.vertical_bleed(s)
    assert_equal expected, s[:avatars]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'collapsed table' do
    # 30 mins = 30 x 3 x 20 secs = 90 tds
    td_nos = [0,1,4,5]
    expected =
    {
      0 => [ :dont_collapse, 0 ],
      1 => [ :dont_collapse, 2 ],
      4 => [ :dont_collapse, 0 ]
    }
    actual = gapper.collapsed_table(td_nos)
    assert_equal expected, actual

    td_nos = [0,1,3,95]
    expected =
    {
      0 => [ :dont_collapse, 0 ],
      1 => [ :dont_collapse, 1 ],
      3 => [ :collapse, 91 ]
    }
    actual = gapper.collapsed_table(td_nos)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'strip removes lightless tds from both ends' do
    t1=make_light(30,21) # 1
    t2=make_light(31,33) # 4
    t3=make_light(30,25) # 1
    t4=make_light(31,37) # 4
    t5=make_light(31,39) # 4
    t6=make_light(31,42) # 5    
    unstripped =
    {
      'hippo' => { 0 => [ ], 1 => [ t1 ], 2 => [ ], 3 => [ ], 4 => [ t2    ], 5 => [    ], 6 => { :collapsed => 4321 }, 4327 => [ ] },
      'lion'  => { 0 => [ ], 1 => [ t3 ], 2 => [ ], 3 => [ ], 4 => [ t4,t5 ], 5 => [    ], 6 => { :collapsed => 4321 }, 4327 => [ ] },
      'panda' => { 0 => [ ], 1 => [    ], 2 => [ ], 3 => [ ], 4 => [       ], 5 => [ t6 ], 6 => { :collapsed => 4321 }, 4327 => [ ] }
    }
    stripped =
    {
      'hippo' => { 1 => [ t1 ], 2 => [ ], 3 => [ ], 4 => [ t2    ], 5 => [    ] },
      'lion'  => { 1 => [ t3 ], 2 => [ ], 3 => [ ], 4 => [ t4,t5 ], 5 => [    ] },
      'panda' => { 1 => [    ], 2 => [ ], 3 => [ ], 4 => [       ], 5 => [ t6 ] }
    }
    assert_equal stripped, gapper.strip(unstripped)
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'fully gapped no traffic_lights yet' do
    all_lights = { }
    now = [year,month,day+1,hour,32,23] #td 4327
    actual = gapper.fully_gapped(all_lights, now)
    expected = { }
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'fully gapped' do
    all_lights =
    {
      'hippo' => [ t1=make_light(30,21), # 1
                   t2=make_light(31,33), # 4
                 ],
      'lion' =>  [ t3=make_light(30,25), # 1
                   t4=make_light(31,37), # 4
                   t5=make_light(31,39), # 4
                 ],
      'panda' => [ t6=make_light(31,42), # 5
                 ]
    }
    expected =
    {
      'hippo' => { 1 => [ t1 ], 2 => [ ], 3 => [ ], 4 => [ t2    ], 5 => [    ] },
      'lion'  => { 1 => [ t3 ], 2 => [ ], 3 => [ ], 4 => [ t4,t5 ], 5 => [    ] },
      'panda' => { 1 => [    ], 2 => [ ], 3 => [ ], 4 => [       ], 5 => [ t6 ] }
    }
    now = [year,month,day+1,hour,32,23] #td 4327
    actual = gapper.fully_gapped(all_lights, now)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  def year; 2011; end
  def month;   5; end
  def day;    18; end
  def hour;    2; end

  def start
    Time.mktime(*[year,month,day,hour,30,0])
  end

  def max_seconds_uncollapsed
    30 * 60
  end
  
  def seconds_per_td
    20
  end

  def make_light(min,sec)
    Tag.new(avatar=nil, { 'time' => [year,month,day,hour,min,sec] })
  end

end
