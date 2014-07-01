require 'json'
require 'Cleaner'

class Lights
  include Enumerable

  def initialize(avatar)
    @avatar = avatar
  end

  def each
    # avatar.lights.each
    lights.each_with_index { |light,n| yield self[n,light] if block_given? }
  end

  def [](n, light = nil)
    # avatar.lights[6]
    Light.new(@avatar, light || lights[n])
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
    return @lights ||= JSON.parse(clean(@avatar.dir.read('increments.json')))
  end

  include Cleaner

end
