
module Runner

  def terminated_after(max_seconds)
    "Terminated by the cyber-dojo server after #{max_seconds} seconds."
  end

  def stderr2stdout(cmd)
    cmd + ' 2>&1'
  end

end