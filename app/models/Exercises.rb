require 'Externals'

class Exercises
  include Enumerable
  include Externals

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def path
    dojo.path + 'exercises/'
  end

  def each
    # dojo.exercises.each
    dir(path).each do |name|
      exercise = self[name]
      yield exercise if exercise.exists?
    end
  end

  def [](name)
    # dojo.exercises['name']
    Exercise.new(self, name)
  end

end
