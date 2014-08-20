# mixin

module TestRunner

  def stderr2stdout(cmd)
    cmd + ' 2>&1'
  end

  def didnt_complete(max_seconds)
    "Unable to complete the tests in #{max_seconds} seconds.\n" +
    "Is there an accidental infinite loop?\n" +
    "Is the server very busy?\n" +
    "Please try again."
  end

end
