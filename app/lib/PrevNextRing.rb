
module PrevNextRing # mix-in

  module_function

  def prev_ring(array,current)
    return '' if array.length === 1
    return array[-1] if array.first === current
    return array[array.rindex(current) - 1]
  end

  def next_ring(array,current)
    return '' if array.length === 1
    return array[0] if array.last === current
    return array[array.index(current) + 1]
  end

end
