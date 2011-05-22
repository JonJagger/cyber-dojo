require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/gap_all_tests.rb

class Gapper
  
  def initialize(start, seconds_per_td)
    @start,@seconds_per_td = start,seconds_per_td
  end

  def td_number(light)    
    ((Time.mktime(*light[:time]) - @start) / @seconds_per_td).to_i
  end

  def stats(all_incs)
    obj = { :avatars => {}, :td_nos => [] }
    avatars = obj[:avatars]    
    all_incs.each do |avatar_name, incs|
      an = avatars[avatar_name] = {}
      incs.each do |inc|
        tdn = td_number(inc)
        an[tdn] ||= [] 
        an[tdn] << inc
        obj[:td_nos] << tdn 
      end
    end
    obj[:td_nos].sort!.uniq!
    obj
  end

  def gap(all_incs)
    s = stats(all_incs) 
    obj = {}
    s[:avatars].each do |avatar_name,kv|
      an = obj[avatar_name] = []
      prev_tdn = 0     
      kv.sort.each do |tdn,incs|
        (prev_tdn ... tdn).each {|n| an << [] }
        an << incs
        prev_tdn = tdn + 1
      end
      (prev_tdn .. s[:td_nos].last).each {|n| an << [] }
    end
    obj
  end
  
end

class GapperTests < ActionController::TestCase
  
  def test_td_number
    year = 2011; month = 5; day = 18; hour = 2;    
    start = Time.mktime(*[year,month,day,hour,30,0])
    seconds_per_td = 20
    # 0 : 2:30:00 - 2:30:20
    # 1 : 2:30:20 - 2:30:40
    # 2 : 2:30:40 - 2:31:00
    # 3 : 2:31:00 - 2:31:20
    # 4 : 2:31:20 - 2:31:40
    # 5 : 2:31:40 - 2:32:00    
    gapper = Gapper.new(start, seconds_per_td)
 
    assert_equal 0, gapper.td_number({ :time => [year,month,day,hour,30,19] })
    assert_equal 1, gapper.td_number({ :time => [year,month,day,hour,30,22] })
    assert_equal 2, gapper.td_number({ :time => [year,month,day,hour,30,58] })
    assert_equal 3, gapper.td_number({ :time => [year,month,day,hour,31,11] })    
  end
   
  def test_td_stats
    year = 2011; month = 5; day = 18; hour = 2;    
    start = Time.mktime(*[year,month,day,hour,30,0])
    seconds_per_td = 20    
    all_incs =
    {
      :hippo => [ t1={ :time => [year,month,day,hour,30,14] }, # 0
                  t2={ :time => [year,month,day,hour,30,27] }, # 1
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
        :hippo => { 0 => [ t1 ], 1 => [ t2 ] },
        :lion  => { 1 => [ t3 ], 4 => [ t4,t5 ] },
        :panda => { 5 => [ t6 ] }
      },
      :td_nos => [0,1,4,5]
    }    
    gapper = Gapper.new(start, seconds_per_td)
    
    assert_equal expected, gapper.stats(all_incs)
  end
  
  def test_no_gaps
    year = 2011; month = 5; day = 18; hour = 2;
    start = Time.mktime(*[year,month,day,hour,30,0])
    seconds_per_td = 20
    all_incs =
    {
      :hippo => [ t1={ :time => [year,month,day,hour,30,14] }, # 0
                  t2={ :time => [year,month,day,hour,30,27] }, # 1
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
      :hippo => [ [ t1 ], [ t2 ], [], [], [], [] ],
      :lion  => [ [], [ t3 ], [], [], [ t4,t5 ], [] ],
      :panda => [ [], [], [], [], [], [ t6 ] ]
    }    
    gapper = Gapper.new(start, seconds_per_td)
    
    assert_equal expected, gapper.gap(all_incs)
  end
  
end




#--------------------------------------------------------------------

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
