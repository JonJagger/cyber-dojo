
# Runner that does nothing.

class NullRunner

  def runnable?(language)
    true
  end

  def run(paas, sandbox, command, max_seconds)
    "No runner found on this server"
  end

end