
module LineSplitter
  
  # - - - - - - - - - - - - - - - - -
  # Note that
  # source = "a\nb"
  #   line_split(source)        --> [ "a, "b" ]
  # and
  #   line_split(source + "\n") --> [ "a, "b" ]
  #
  # Viz, if the last character is a \n it is 'lost'
  # This means that it is not guaranteed that
  # line_split(source).join("\n") == source
  # - - - - - - - - - - - - - - - - -
  # See tests/lib/line_splitter_tests.rb
  
  def self.line_split(source)
    if source == nil
      [ ]
    elsif source == ""
      [ "" ]
    else
      lines = source.split(/\n/,-1)
      lines.pop if lines.last == ""
      lines
    end
  end
  
end

