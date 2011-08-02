
# See test/functional/sameify_tests.rb

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

# See test/functional/line_split_tests.rb

def line_split(source)
  source ||= ""
  source.split(/(\n)/).select { |line| line != "\n" }
end

# Note that
# source = "a\nb"
# line_split(source) --> [ "a, "b" ]
#
# and
#
# line_split(source + "\n") --> [ "a, "b" ]
#
# Viz, if the last character is a \n it is 'lost'
# This means that it is not guaranteed that
# line_split(source).join("\n") == source
