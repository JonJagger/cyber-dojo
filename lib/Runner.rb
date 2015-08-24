
module Runner # mix-in

  module_function

  include Cleaner

  def didnt_complete(max_seconds)
    "Unable to complete the tests in #{max_seconds} seconds.\n" +
    "Is there an accidental infinite loop?\n" +
    "Is the server very busy?\n" +
    "Please try again."
  end

  def max_output_length
    50*1024
  end
  
  def limited(output)
    output = clean(output)
    # for example, a C++ source file that #includes
    # itself can generate 7MB of output...
    if output.length > max_output_length
      output = output.slice(0, max_output_length)
      output += "\n"
      output += "output truncated by cyber-dojo server"
    end
    output
  end

end
