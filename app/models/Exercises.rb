require 'Externals'

# dojo.exercises['name']
# dojo.exercises.each{|exercise| ...}

class Exercises
  include Enumerable
  include Externals

  def initialize(path)
    @path = path
  end

  attr_reader :path

  def each
    dir.each do |name|
      exercise = self[name]
      yield exercise if exercise.exists? && block_given?
    end
  end

  def [](name)
    Exercise.new(self,name)
  end

end
