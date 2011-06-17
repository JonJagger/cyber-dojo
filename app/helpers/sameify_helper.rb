module SameifyHelper
  
  def sameify(source)
    result = []
    line_split(source).each_with_index do |line,number|
      result << {
        :line => line,
        :type => :same,
        :number => number + 1
      }
    end
    result
  end

end

