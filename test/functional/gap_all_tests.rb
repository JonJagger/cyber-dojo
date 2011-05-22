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
    all_incs.each do |avatar_name, incs|
      an = obj[:avatars][avatar_name] = {}
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

  def filler_tds(an, td_nos, from, to)
    if to == nil
      to = td_nos.length != 0 ? td_nos.last : from
      to += 1
    end
    (from...to).each { |n| an << :gap }
  end
  
  def gap(all_incs)
    s = stats(all_incs) 
    obj = {}
    s[:avatars].each do |avatar_name,kv|
      an = obj[avatar_name] = []
      prev_tdn = 0     
      kv.sort.each do |tdn,incs|
        filler_tds(an, s[:td_nos], prev_tdn, tdn)
        an << incs
        prev_tdn = tdn + 1
      end
      filler_tds(an, s[:td_nos], prev_tdn, nil)  
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
  
  def test_gaps_but_no_collapsed_gaps
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
      :hippo => [ [ t1 ], [ t2 ], :gap, :gap, :gap, :gap ],
      :lion  => [ :gap, [ t3 ], :gap, :gap, [ t4,t5 ], :gap ],
      :panda => [ :gap, :gap, :gap, :gap, :gap, [ t6 ] ]
    }    
    gapper = Gapper.new(start, seconds_per_td)
    
    assert_equal expected, gapper.gap(all_incs)
  end
  
  def test_collapsed_gaps
    # Suppose I have :hippo with lights for td's numbered 5 and 15 
    # and that the time this gap represents is large enough to be collapsed. 
    # Does this mean the hippo's tr gets 10 empty td's between the 
    # td#5 and the td#15 (each of which contains at least one light). 
    # The answer is it depends on the other avatars. 
    # The td's have to align vertically. 
    # For example if the :lion has a td at 11 then
    # this effectively means that for the hippo its 5-15 has to be
    # considered as 5-11-15
    # This is where the :td_nos array comes in. 
    # Suppose the :td_nos array is [1,5,11,13,15,16,18,23]
    # This means that the hippo has to treat its 5-15 gap as 5-11-13-15
    # There can be multiple genuine "lit" td's (11,13) from other avatars
    # and we can't collapse "across" or "through" these.
    # Thus the time gaps between (5,11) (11,13) (13,15) are what need
    # to be considered to see if a special collapsed td gets used.
    # For example, suppose a dojo runs over two days, there would be a long
    # period of time at night when no traffic lights would get added. Thus
    # the :td_nos array is likely to have large gaps, 
    # eg [....450,1236,1237,...]
    # at 20 seconds per gap the difference between 450 and 2236 is 1786
    # and 1786*20 == 35,720 seconds == 9 hours 55 mins 20 secs
    # and we would want this collapsed to a single special td.
    #
    # Of course you could get a situation where the consecutive td numbers
    # for an avatar are something like 34,3675 and the :td_nos array for 
    # contains several collapsed gaps interspersed with lights from other
    # avatars.
    #
    # It is clear that I only need to calculate the empty fillers td's 
    # and the collapsed td's once for the whole :td_nos array.
    # Consider N = td_nos[i] and M = td_nos[i+1]
    # and an avatar wanting to process one or more lights in a td at 
    # position i. You have to first create a td and fill it with the lights.
    # It then has to consider if M-N is less than the collapse limit,
    #   If it is it has to add M-N-1 empty td's.
    #   If if isn't it add a single collapsed td.
    # And this has to be done in a loop. An avatar wanting to fill in
    # between td's at positions [p] and [q] has to process all (i, i+1) 
    # pairs between p and q. 
    

    
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
