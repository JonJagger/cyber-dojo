
# regular split doesn't do what I need...   
# assert_equal [], "\n\n".split("\n")
# So I have to roll my own...
    
def line_split(source)
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

