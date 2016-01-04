
module OutputTruncater # mix-in

  module_function

  def truncated(output)
    # for example, a C++ source file that #includes
    # itself can generate 7MB of output...
    if output.length > max_output_length
      output = output.slice(0, max_output_length)
      output += "\n"
      output += "output truncated by cyber-dojo server"
    end
    output
  end

  def max_output_length
    50 * 1024
  end

end
