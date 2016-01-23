
class Exercises
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
    @path = config['root']['exercises']
    ensure_cache_exists
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
    caches.read_json(self.class.cache_filename).each do |name, exercise|
      cache[name] = make_exercise(name, exercise['instructions'])
    end
    cache
  end

  def write_cache
    cache = {}
    dir.each_dir do |sub_dir|
      exercise = make_exercise(sub_dir)
      cache[exercise.name] = { instructions: exercise.instructions }
    end
    caches.write_json(self.class.cache_filename, cache)
  end

  def ensure_cache_exists
    filename = caches.path + self.class.cache_filename
    return if File.exist?(filename)
    File.open(filename, File::RDWR|File::CREAT, 0644) do |fd|
      if fd.flock(File::LOCK_EX|File::LOCK_NB)
        write_cache
      else # something else is making the cache, wait till it completes
        fd.flock(File::LOCK_EX)
      end
    end
  end

  def self.cache_filename
    'exercises_cache.json'
  end

  def make_exercise(name, instructions = nil)
    Exercise.new(self, name, instructions)
  end

end
