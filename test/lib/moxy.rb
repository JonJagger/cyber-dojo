
# A Moxy is a MockProxy. It mostly acts as a proxy,
# but if a mock expectation is setup then that is
# called instead.

class Moxy

  def initialize(_dojo)
    @mocks = []
  end

  def teardown
    fail "unused mocks for #{@mocks}" unless @mocks.empty?
  end

  def proxy(target)
    fail "cannot set proxy to nil" if target.nil?
    @target = target
  end

  def method_missing(command, *args)
    fail RuntimeError.new("@target.nil?") if @target.nil?
    if @mocks.empty?
      return @target.send(command, *args)
    else
      mock = @mocks.shift
      fail RuntimeError.new(
        "expecting: #{mock[0]}\n" +
        "   actual: #{command}") unless mock[0] == command
      return mock[1].call(*args)
    end
  end

  def mock(command, &block)
    fail RuntimeError.new("@target.nil?") if @target.nil?
    fail RuntimeError.new("!@target.respond_to?(#{command})") if !@target.respond_to?(command)
    @mocks << [command, block]
  end

end
