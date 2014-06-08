
class Lights
  include Enumerable

  def initialize(avatar)
    @avatar = avatar
  end

  attr_reader :avatar

  def each
    # avatar.lights.each
    lights.each_with_index { |light,n| yield self[n,light] if block_given? }
  end

  def [](n, light = nil)
    # avatar.lights[6]
    Light.new(avatar, light || lights[n])
  end

  def length
    lights.length
  end

  def latest
    self[length-1]
  end

  #def <<(light)
  #  ...
  #  @lights = nil  (reset cache)
  #end

private

  def paas
    avatar.kata.dojo.paas
  end

  def lights
    return @lights ||= JSON.parse(JSON.unparse(eval(text))) if format === 'rb'
    return @lights ||= JSON.parse(text) if format === 'json'
  end

  def text
    raw = paas.read(avatar, traffic_lights_filename)
    raw.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def traffic_lights_filename
    'increments.' + format
  end

  def format
    avatar.format
  end

end
