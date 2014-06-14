require 'Externals'

# dojo.exercises['name']
# dojo.exercises.each{|exercise| ...}

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
    dir.each do |name|
      exercise = self[name]
      yield exercise if exercise.exists?
    end
  end

  def [](name)
    Exercise.new(self, name)
  end

end
