# I want horizontal spacing between dashboard traffic lights  
# proportional to the time difference between them.
#
# I also want traffic-lights from different avatars but occurring at
# the same moment in time to align vertically.
#
# These two requirements are somewhat in tension with each other.
# The best solution I can think of is to split each avatar's traffic light tr
# into the same number of td's and make each td represent a period of time,
# say 15 seconds.
#
# The start time will be the start time of the dojo. 
# The end time will be the current time.
# 
# As time passes, traffic lights from the past move backwards (left).
# The page auto refreshes via a periodic ajax call so it won't
# work to have horizontal scrollbars if the width of the display (the time
# between start and end) increases. So I limit the display to a maximum
# number of td's. 
#
# If there are a lot of empty td's in a row (for all avatars) I collapse them 
# all into a single td (for all avatars). This ensures that the display never 
# shows just empty td's except if the dojo has just started.

class TdGapper

  def initialize(start, seconds_per_td, max_seconds_uncollapsed)
    @start = start
    @seconds_per_td = seconds_per_td    
    @max_seconds_uncollapsed = max_seconds_uncollapsed
  end

  def number(light)    
    ((Time.mktime(*light[:time]) - @start) / @seconds_per_td).to_i
  end

  def stats(all_incs, now)
    obj = {
      :avatars => { },
      :td_nos => [ 0, number({:time => now}) ]
    }
    all_incs.each do |avatar_name, incs|
      an = obj[:avatars][avatar_name] = { }
      incs.each do |inc|
        tdn = number(inc)
        an[tdn] ||= [ ] 
        an[tdn] << inc
        obj[:td_nos] << tdn 
      end
    end
    obj[:td_nos].sort!.uniq!
    obj
  end

  def vertical_bleed(s)
    s[:td_nos].each do |n|
      s[:avatars].each do |name,td_map|
        td_map[n] ||= [ ]
      end
    end
  end
  
  def collapsed_table(td_nos)
    max_uncollapsed_tds = @max_seconds_uncollapsed / @seconds_per_td
    obj = { }
    td_nos.each_cons(2) do |p|
      diff = p[1] - p[0]
      key = diff < max_uncollapsed_tds ? :tds : :collapsed
      obj[p[0]] = [ key, diff-1 ]
    end
    obj
  end

  def fully_gapped(all_incs, now)
    s = stats(all_incs, now)
    vertical_bleed(s)
    collapsed_table(s[:td_nos]).each do |td,gi|
      count = gi[1]
      s[:avatars].each do |name,td_map|
        if gi[0] == :tds # short gap, show all td's
          count.times {|n| td_map[td+n+1] = [ ] }
        end
        if gi[0] == :collapsed # long gap, collapse to one td
          td_map[td+1] = { :collapsed => count }
        end
      end
    end
    s[:avatars] 
  end

end

