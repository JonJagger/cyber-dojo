
class Exercises

  include Enumerable

  def initialize(path,disk)
    @path,@disk = path,disk
    cache_from_manifest
  end

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
    Exercise.new(path,name,@disk)
  end

  def dir
    @disk[path]
  end

  def cache_from_manifest
    if dir.exists?(manifest_filename)
       fake = FakeDisk.new
       manifest = JSON.parse(dir.read(manifest_filename))
       manifest.each do |name,instructions|
        fake[path + name].write('instructions',instructions)
      end
      @disk = fake
    end
  end

  def manifest_filename
    # created with cyber-dojo/exercises/cache.rb
    'manifest.json'
  end

  attr_reader :path

end
