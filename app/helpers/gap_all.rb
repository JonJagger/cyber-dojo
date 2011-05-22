
  # I'd like the horizontal spacing between dashboard traffic lights to be 
  # proportional to the time difference between them. I first tried this
  # by calculating the number of seconds between traffic lights. However
  # this is not satifactory because each traffic light itself takes up a 
  # certain width. Hence an avatar hitting the run-tests button a lot
  # will naturally takes up quite a lot of horizontal space and the display 
  # loses the vital property of relative horizontal position indicating relative
  # moments in time.
  #
  # The best solution I can think of is to split each avatar's traffic light tr
  # into the same number of td's and make each td represent a period of time,
  # say 15 seconds.
  # The start time will be the start time of the dojo. At first I had the end 
  # time of the dojo as being the current time. But this is flawed. The reason
  # is that as time passes, traffic lights from the past move backwards. And it
  # doesn't make sense to even consider display anything for the time between
  # the last traffic-light and the current date/time in the non-refreshing, 
  # scrollbar based view.
  #
  # What I need to do
  # -----------------
  # Have a function that calculates the td-number of a traffic light
  # based on the dojo start time and the time of the last traffic-light.
  # Use this for all traffic-lights of all avatars.
  # If there are periods greater than 30 mins (which could roughly
  # correspond to the time period can be shown on the time-shifting auto
  # updating display), then collapse all these td's into a single td with a
  # special css class which displays as ellision in some way...
  
def gap_all(all_incs, created, now, seconds_per_gap)
  now = latest(all_incs) # fixme (no need to pass parameter)
  gaps = time_gaps(created, now, seconds_per_gap)
  full = {}
  all_incs.each do |avatar_name, incs|
    full[avatar_name] = gap_one(incs, gaps)
  end
  full
end

def time_gaps(from, to, seconds_per_gap)
  n = (to - from) / seconds_per_gap
  (0..n+1).collect {|i| from + i * seconds_per_gap }
end

def gap_one(lights, gaps)
  chunks = []
  gaps.each_cons(2) do |t1,t2|
    chunk,lights = lights.partition do |light|  
      at = Time.mktime(*light[:time])
      t1 < at && at <= t2
    end
    chunks << chunk
  end    
  chunks
end

def latest(all_incs)
  current = nil
  all_incs.each do |avatar_name, incs|
    if incs.length != 0
      at = Time.mktime(*incs.last[:time])
      if !current  || at > current
        current = at
      end
    end
  end
  current
end

