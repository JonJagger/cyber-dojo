
module AgeHelper

  # Used on dashboard

  def age_from_seconds(secs)
    [secs / (60*60*24), (secs / (60*60)) % 24, (secs / 60) % 60, secs % 60]
  end
  
  def formatted_age_from_seconds(s)
    days,hours,minutes,seconds = age_from_seconds(s)
    if days==0 && hours==0 && minutes==0
      return ":%02d" % seconds
    elsif days==0 && hours==0
      return "%02d:%02d" % [minutes,seconds]
    elsif days==0
      return "%02d:%02d:%02d" % [hours,minutes,seconds]
    else
      return "%d:%02d:%02d:%02d" % [days,hours,minutes,seconds]
    end
  end
end
