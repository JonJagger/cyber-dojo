
class Exercises

  include Enumerable

  def initialize(path)
    @path = path
  end

  attr_reader :path

  def each
    # dojo.exercises.each { |exercise| ... }
    exercises.each do |exercise|
      yield exercise if block_given?
    end
  end

  def [](name)
    # dojo.exercises[name]
    make_exercise(name)
  end

private

  include Externals

  def exercises
    @exercises ||= make_cache
  end

  def make_cache
    cache = [ ]
    dir.each do |sub_dir|
      exercise = make_exercise(sub_dir)
      cache << exercise if exercise.exists?
    end
    cache
  end

  def make_exercise(name)
    Exercise.new(path,name)
  end

  def dir
    disk[path]
  end

end
