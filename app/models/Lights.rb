root = '../..'
require_relative root + '/app/lib/Cleaner'
require 'json'

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

  def count
    lights.count
  end

  def latest
    self[count-1]
  end

private

  include Cleaner

  def lights
    @lights ||= JSON.parse(clean(@avatar.dir.read('increments.json')))
  end

end
