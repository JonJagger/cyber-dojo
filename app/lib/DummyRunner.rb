
# Runner that does nothing.

class DummyRunner

  def runnable?(language)
    false
  end

  def run(sandbox, command, max_seconds)
    ""
  end

end