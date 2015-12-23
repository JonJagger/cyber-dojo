
module OutputOrKilled # mix-in

  module_function

  def output_or_killed(run_result, max_seconds)
    output, exit_status = *run_result
    exit_status != timed_out ? output : did_not_complete(max_seconds)
  end

  def did_not_complete(max_seconds)
    "Unable to complete the tests in #{max_seconds} seconds.\n" +
    "Is there an accidental infinite loop?\n" +
    "Is the server very busy?\n" +
    "Please try again."
  end

  def timed_out
    (timeout = 128) + (kill = 9)
  end

end
