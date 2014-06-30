
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

  def lights
    return @lights ||= JSON.parse(text)
  end

  def text
    raw = avatar.dir.read(traffic_lights_filename)
    clean(raw)
  end

  def traffic_lights_filename
    'increments.json'
  end

  def clean(s)
    s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    s = s.encode('UTF-8', 'UTF-16')
  end

end
