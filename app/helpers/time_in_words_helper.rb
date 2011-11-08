require 'plural_helper'

module TimeInWordsHelper

  include PluralHelper

  # Something akin to git log --relative-date option
  # Used on dashboard
  
  def time_in_words(seconds)
    years,days,hours,minutes,seconds = time_split(seconds)
    
    if years > 0
      t = 'about ' + plural(years, 'year')
      t = t + ' ' + plural(days, 'day') if days > 0
    elsif days > 0
      t = 'about ' + plural(days, 'day')
      t = t + ' ' + plural(hours, 'hour') if hours > 0
    elsif hours > 0
      t = 'about ' + plural(hours, 'hour')
      t = t + ' ' + plural(minutes, 'minute') if minutes > 0
    elsif minutes > 0
      t = plural(minutes, 'minute')
      t = t + ' ' + plural(seconds, 'second') if seconds > 0
    else  
      t = plural(seconds, 'second')
    end
    t
  end
  
  def time_split(seconds)
    minutes,seconds = seconds.divmod(60)
    hours,minutes = minutes.divmod(60)
    days,hours = hours.divmod(24)
    years,days = days.divmod(365)
    
    [years,days,hours,minutes,seconds]
  end
  
  def time_unsplit(years, days, hours, minutes, seconds)
    seconds_per_min  = 60
    seconds_per_hour = 60*60
    seconds_per_day  = 24*60*60
    seconds_per_year = 365*24*60*60
  
    years * seconds_per_year + 
    days * seconds_per_day + 
    hours * seconds_per_hour + 
    minutes * seconds_per_min +
    seconds
  end
  
end