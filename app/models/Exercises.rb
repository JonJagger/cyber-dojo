
class Exercises
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    # dojo.exercises.each
    paas.dir(self).each { |name| yield self[name] if self[name].exists? }
  end

  def [](name)
    # dojo.exercises['name']
    Exercise.new(dojo, name)
  end

private

  def paas
    dojo.paas
  end

end
