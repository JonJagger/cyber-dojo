
module TestRunner # mixin

  def didnt_complete(max_seconds)
    "Unable to complete the tests in #{max_seconds} seconds.\n" +
    "Is there an accidental infinite loop?\n" +
    "Is the server very busy?\n" +
    "Please try again."
  end

  def limited(output)
    output = clean(output)
    # for example, a C++ source file that #includes
    # itself can generate 7MB of output...
    max_length = 50*1024
    if output.length > max_length
      output = output.slice(0, max_length)
      output += "\n"
      output += "output truncated by cyber-dojo server"
    end
    output
  end

private

  include Cleaner  

end
