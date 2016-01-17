
module StderrRedirect # mix-in

  module_function

  def stderr_2_stdout
    '2>&1'
  end

end
