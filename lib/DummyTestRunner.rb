
# Runner that does nothing.

__DIR__ = File.dirname(__FILE__)

require __DIR__ + '/TestRunner'

class DummyTestRunner

  def runnable?(language)
    false
  end

  def run(sandbox, command, max_seconds)
    ""
  end

end