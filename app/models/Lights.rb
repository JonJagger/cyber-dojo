require 'json'
require 'Cleaner'

class Lights
  include Enumerable

  def initialize(avatar)
    @avatar = avatar
  end

  def each
    # avatar.lights.each
    lights.each { |light| yield Light.new(@avatar,light) if block_given? }
  end

  def [](n)
    # avatar.lights[6]
    Light.new(@avatar, lights[n])
  end

  def length
    lights.length
  end

  def latest
    self[length-1]
  end

private

  def lights
    @lights ||= JSON.parse(clean(@avatar.dir.read('increments.json')))
  end

  include Cleaner

end
