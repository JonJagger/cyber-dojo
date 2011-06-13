
def recent(array, max_length)
  len = [array.length, max_length].min
  array[-len,len]
end

