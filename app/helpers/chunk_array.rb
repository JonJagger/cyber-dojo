
def chunk_array(array, pieces)
  len = array.length;
  mid = (len / pieces)
  chunks = []
  start = 0
  1.upto(pieces) do |i|
    last = start + mid
    last = last-1 unless len % pieces >= i
    chunk = array[start..last]
    if chunk != []
      chunks << chunk
    end
    start = last + 1
  end
  chunks
end

