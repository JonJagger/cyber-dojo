
module Runner

  def terminated(max_seconds)
    "Terminated by the cyber-dojo server after #{max_seconds} seconds."
  end

  def with_stderr(cmd)
    cmd + ' 2>&1'
  end

end