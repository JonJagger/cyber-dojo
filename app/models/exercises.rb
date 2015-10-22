# See comments at end of file

class Exercises
  include Enumerable

  def self.cache_filename
    'exercises_cache.json'
  end

  def initialize(dojo, path)
    @parent = dojo
    @path = path
    @path += '/' unless @path.end_with? '/'
  end

  attr_reader :path

  def each(&block)
    exercises.values.each(&block)
  end

  def [](name)
    exercises[name]
  end

  def refresh_cache
    cache = {}
    dir.each_dir do |sub_dir|
      exercise = make_exercise(sub_dir)
      cache[exercise.name] = { instructions: exercise.instructions }
    end
    write_json(self.class.cache_filename, cache)
  end

  private

  include ExternalParentChain

  def exercises
    @exercises ||= read_cache
  end

  def read_cache
    cache = {}
    read_json(self.class.cache_filename).each do |name, exercise|
      cache[name] = make_exercise(name, exercise['instructions'])
    end
    cache
  end

  def make_exercise(name, instructions = nil)
    Exercise.new(self, name, instructions)
  end

end
