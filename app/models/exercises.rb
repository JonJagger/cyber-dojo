
class Exercises
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
    @path = config['root']['exercises']
    caches.write_json_once(cache_filename) { make_cache }
  end

  # queries

  def path
    slashed(@path)
  end

  def parent
    @dojo
  end

  def each(&block)
    exercises.values.each(&block)
  end

  def [](name)
    exercises[name]
  end

  private

  include ExternalParentChainer
  include ExternalDir
  include Slashed

  def exercises
    @exercises ||= read_cache
  end

  def read_cache
    cache = {}
    caches.read_json(cache_filename).each do |name, exercise|
      cache[name] = make_exercise(name, exercise['instructions'])
    end
    cache
  end

  def make_cache
    cache = {}
    dir.each_dir do |sub_dir|
      exercise = make_exercise(sub_dir)
      cache[exercise.name] = { instructions: exercise.instructions }
    end
    cache
  end

  def cache_filename
    'exercises_cache.json'
  end

  def make_exercise(name, instructions = nil)
    Exercise.new(self, name, instructions)
  end

end
