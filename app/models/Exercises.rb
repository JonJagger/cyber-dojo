
class Exercises

  include Enumerable

  def initialize(path,disk)
    @path,@disk = path,disk
  end

  attr_reader :path

  def each
    # dojo.exercises.each{|exercise| ...}
    cache.each do |exercise|
      yield exercise if block_given?
    end
  end

  def [](name)
    # dojo.exercises['name']
    make_exercise(name)
  end

private

  def cache
    @cache ||= make_cache
  end

  def make_cache
    made = [ ]
    dir.each do |sub_dir|
      exercise = make_exercise(sub_dir)
      made << exercise if exercise.exists?
    end
    made
  end

  def make_exercise(name)
    Exercise.new(path,name,@disk)
  end

  def dir
    @disk[path]
  end

end
