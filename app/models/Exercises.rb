
class Exercises

  include Enumerable

  def initialize(path,disk)
    @path,@disk = path,disk
  end

  attr_reader :path

  def each
    # dojo.exercises.each{|exercise| ...}
    dir.each do |name|
      exercise = self[name]
      yield exercise if exercise.exists? && block_given?
    end
  end

  def [](name)
    # dojo.exercises['name']
    Exercise.new(path,name,@disk)
  end

private

  def dir
    @disk[path]
  end

end
