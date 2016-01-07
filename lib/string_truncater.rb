
module StringTruncater # mix-in

  module_function

  def truncated(s)
    max_length = 10 * 1024
    # for example, a C++ source file that #includes
    # itself can generate 7MB of output...
    if s.length > max_length
      s = s.slice(0, max_length)
      s += "\n"
      s += "output truncated by cyber-dojo server"
    end
    s
  end

end
