
class Exercises
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    dojo.paas.exercises_each(self) do |name|
      yield self[name]
    end
  end

  def [](name)
    Exercise.new(dojo, name)
  end

end
