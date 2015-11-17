
module DidNotCompleteIn # mix-in

  module_function

  def did_not_complete_in(max_seconds)
    "Unable to complete the tests in #{max_seconds} seconds.\n" +
    "Is there an accidental infinite loop?\n" +
    "Is the server very busy?\n" +
    "Please try again."
  end

end
