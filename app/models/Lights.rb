
class Lights
  include Enumerable

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def each
    lights.each_with_index { |light,n| yield self[n,light] if block_given? }
  end

  def [](n, light = nil)
    Light.new(avatar, light || lights[n])
  end

  def length
    each.entries.length
  end

private

  def paas
    avatar.kata.dojo.paas
  end

  def lights
    result = JSON.parse(paas.read(avatar, traffic_lights_filename))
  end

  def traffic_lights_filename
    'increments.' + format
  end

  def format
    avatar.format
  end

end
