
def line_split(source)
  source.split(/(\n)/).select { |line| line != "\n" }
end


