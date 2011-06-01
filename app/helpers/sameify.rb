
def sameify(source)
  result = []
  source.split("\n").each_with_index do |line,number|
    result << {
      :line => line,
      :type => :same,
      :number => number + 1
    }
  end
  result
end


