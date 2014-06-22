
# dojo.exercises['name']
# dojo.exercises.each{|exercise| ...}

class Exercises
  include Enumerable

  def initialize(path,disk)
    @path,@disk = path,disk
  end

  attr_reader :path

  def each
    dir.each do |name|
      exercise = self[name]
      yield exercise if exercise.exists? && block_given?
    end
  end

  def [](name)
    Exercise.new(self,name,@disk)
  end

private

  def dir
    @disk[path]
  end

end
