
class Exercises

  include Enumerable

  def initialize(path,disk)
    @path,@disk = path,disk
    #@cached = { }
    #dir.each do |name|
    #  exercise = Exercise.new(path,name,@disk)
    #  @cached[name] = exercise if exercise.exists?
    #end
  end

  attr_reader :path

  def each
    # dojo.exercises.each{|exercise| ...}
    dir.each do |name|
      exercise = self[name]
      yield exercise if exercise.exists? && block_given?
    end
    #@cached.each_value do |exercise|
    #  yield exercise if block_given?
    #end
  end

  def [](name)
    # dojo.exercises['name']
    Exercise.new(path,name,@disk)
    #@cached[name]
  end

private

  def dir
    @disk[path]
  end

end
