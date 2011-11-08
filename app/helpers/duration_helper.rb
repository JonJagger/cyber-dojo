
module DurationHelper

  def duration_in_minutes(started, finished)
    duration_in_seconds(started,finished) / 60
  end
  
  def duration_in_seconds(started, finished)
    (finished - started).to_i
  end
 
end
