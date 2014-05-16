
# Runner that does nothing.

class DummyRunner

  def runnable?(language)
    false
  end

  def run(paas, sandbox, command, max_seconds)
    ""
  end

end