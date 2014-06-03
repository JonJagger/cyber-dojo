
# Designed to allow...
#
# o) dojo.exercises['name'] to access a specific exercise
# o) dojo.exercises.each to iterate through a dojo's exercises

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
