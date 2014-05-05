
class Exercises
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    paas.all_exercises(self).each { |name| yield self[name] }
  end

  def [](name)
    Exercise.new(dojo, name)
  end

private

  def paas
    dojo.paas
  end

end
