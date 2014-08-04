
# See test/app-lib/test_td_gapper.rb

class TdGapper

  def initialize(start, seconds_per_td, max_seconds_uncollapsed)
    @start = start
    @seconds_per_td = seconds_per_td
    @max_seconds_uncollapsed = max_seconds_uncollapsed
  end

  def fully_gapped(all_lights, now)
    s = stats(all_lights, now)
    vertical_bleed(s)
    collapsed_table(s[:td_nos]).each do |td,gi|
      count = gi[1]
      s[:avatars].each do |name,td_map|
        if gi[0] === :dont_collapse
          count.times {|n| td_map[td+n+1] = [ ] }
        end
        if gi[0] === :collapse
          td_map[td+1] = { :collapsed => count }
        end
      end
    end
    s[:avatars]
  end

  def stats(all_lights, now)
    obj = {
      :avatars => { },
      :td_nos  => [ 0, n(now) ]
    }
    all_lights.each do |avatar_name, lights|
      an = obj[:avatars][avatar_name] = { }
      lights.each do |light|
        tdn = number(light)
        an[tdn] ||= [ ]
        an[tdn] << light
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
      key = diff < max_uncollapsed_tds ? :dont_collapse : :collapse
      obj[p[0]] = [ key, diff-1 ]
    end
    obj
  end

  def number(light)
    ((light.time - @start) / @seconds_per_td).to_i
  end

  def n(now)
    ((Time.mktime(*now) - @start) / @seconds_per_td).to_i
  end


end

# I want the horizontal spacing between dashboard traffic lights
# to be proportional to the time difference between them.
#
# I also want traffic-lights from different avatars but occurring at
# the same moment in time to align vertically.
#
# These two requirements are somewhat in tension with each other.
# The best solution I can think of is to split each avatar's traffic light tr
# into the same number of td's by making each td represent a period of time,
# say 15 seconds.
#
# The start time will be the start time of the dojo.
# The end time will be the current time.
#
# If there are a lot of empty td's in a row (for all avatars) I collapse them
# all into a single td (for all avatars). This ensures that the display never
# shows just empty td's except if the dojo has just started.

# collapsed_table
# ---------------
# Suppose I have :hippo with lights for td's numbered 5 and 15
# and that the time this gap (from 5 to 15, viz 9 td's) represents
# is large enough to be collapsed.
# Does this mean the hippo's tr gets 9 empty td's between the
# td#5 and the td#15?
# The answer is it depends on the other avatars.
# The td's have to align vertically.
# For example if the :lion has a td at 11 then
# this effectively means that for the :hippo its 5-15 has to be
# considered as 5-11-15 and the gaps are really 5-11 (5 td gaps)
# and 11-15 (3 td gaps).
# This is where the :td_nos array comes in.
# It is an array of all td numbers for a dojo across all avatars.
# Suppose the :td_nos array is [1,5,11,13,15,16,18,23]
# This means that the hippo has to treat its 5-15 gap as 5-11-13-15
# so the gaps are really 5-11 (5 td gaps), 11-13 (1 td gap) and 13-15
# (1 td gap). Note that the :hippo doesn't have a light at either 13 or 15
# but that doesn't matter, we can't collapse "across" or "through" these
# because I want vertical consistency.

# Now, suppose a dojo runs over two days, there would be a long
# period of time at night when no traffic lights would get added. Thus
# the :td_nos array is likely to have large gaps,
# eg [....450,2236,2237,...]
# at 20 seconds per gap the difference between 450 and 2236 is 1786
# and 1786*20 == 35,720 seconds == 9 hours 55 mins 20 secs.
# We would not want this displayed as 1786 empty td's!
# Thus there is a max_seconds_uncollapsed parameter. If the time difference
# between two consecutive entries in the :td_nos array is greater than
# max_seconds_uncollapsed the display will not show one td for each
# gap but will collapse the entire gap down to one td.
# A collapsed td is shown with a ... in it.
