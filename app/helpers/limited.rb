
def limited(increments)
  max_increments_displayed = 8
  len = [increments.length, max_increments_displayed].min
  increments[-len,len]
end

