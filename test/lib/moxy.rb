
# A Moxy is a MockProxy. It mostly acts as a proxy,
# but if a mock expectation is setup then that is
# called instead.

class Moxy

  def initialize(_dojo)
    @mocks = {}
    #ObjectSpace.define_finalizer(self, proc { assert_no_mocks })
  end

  def proxy(target)
    fail "cannot set proxy to nil" if target.nil?
    fail "proxy already set" unless @target.nil?
    @target = target
  end

  def method_missing(command, *args)
    fail RuntimeError.new("@target.nil?") if @target.nil?
    if @mocks[command].nil?
      return @target.send(command, *args)
    else
      mock = @mocks[command]
      @mocks.delete(command)
      return mock.call(*args)
    end
  end

  def mock(command, &block)
    fail RuntimeError.new("@target.nil?") if @target.nil?
    fail RuntimeError.new("!@target.respond_to?(#{command})") if !@target.respond_to?(command)
    assert_no_mocks
    @mocks[command] = block
  end

  private

  def assert_no_mocks
    if !@mocks.empty?
      raise RuntimeError.new [ self.class.name, "unused mocks: #{@mocks.keys}" ].join("\n")
    end
  end

end
