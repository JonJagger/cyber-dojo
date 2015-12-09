
class HostLog

  def initialize(_dojo)
    @messages = []
  end

  def <<(message)
    @messages << message
  end

  def include?(find)
    @messages.any? { |message| message.include?(find) }
  end

  def to_s
    @messages.to_s
  end

end
