
class Exercises

  def initialize
    @exercises_path = exercises_path
    @exercises_path += '/' if !exercises_path.end_with?('/')
  end

  def path
    @exercises_path
  end

  def each
    return enum_for(:each) unless block_given?
    exercises.each do |exercise|
      yield exercise
    end
  end

  def [](name)
    make_exercise(name)
  end

private

  include ExternalDiskDir
  include ExternalExercisesPath

  def exercises
    @exercises ||= make_cache
  end

  def make_cache
    cache = [ ]
    dir.each_dir do |sub_dir|
      exercise = make_exercise(sub_dir)
      cache << exercise if exercise.exists?
    end
    cache
  end

  def make_exercise(name)
    Exercise.new(path,name)
  end

end
