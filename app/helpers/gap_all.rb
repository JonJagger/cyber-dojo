
  # I'd like the horizontal spacing between dashboard traffic lights to be 
  # proportional to the time difference between them. I first tried this
  # by calculating the number of seconds between traffic lights. However
  # this is not satifactory because each traffic light itself takes up a 
  # certain width. Hence an avatar hitting the run-tests button a lot
  # will naturally takes up quite a lot of horizontal space. The best
  # solution I can think of is to split each avatar's traffic light tr into 
  # the same number of td's and make each td represent a fixed period of time,
  # say 15 seconds.
  # The start time will be the start time of the dojo, and the end time will
  # be the current time. This means that as time passes, traffic lights from 
  # the past move backwards.
  # I don't want scroll-bars since the traffic-lights on the dashboard 
  # automatically refresh every few seconds and this would interfere with
  # the scrolling. The best way to combat this is to limit the number of
  # td's on a tr, and if there are too many, to simply chop off early ones.
  # This is what I do on the main play page where I limit the number of
  # traffic-lights to only a few (eg 7) and I don't space them out.

def gap_all(all_incs, created, now, seconds_per_gap)
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


