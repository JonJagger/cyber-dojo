
module RecentHelper
  
  # There is limited horizontal space to display traffic-lights.
  # This function takes an array and assumes the oldest elements
  # live at the smallest indexes and the newest elements live at
  # the largest indexes. It returns the most recent max_length
  # elements from array, or if the length of the array is less
  # than max_length, it returns the whole array.
  #
  # See test/unit/recent_tests.rb
  
  def recent(array, max_length)
    len = [array.length, max_length].min
    array[-len,len]
  end

end