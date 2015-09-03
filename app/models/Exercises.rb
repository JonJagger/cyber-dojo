# See comments at end of file

class Exercises

  include ExternalParentChain
  include Enumerable
  
  def initialize(dojo,path)
    @parent,@path = dojo,path
    @path += '/' if !@path.end_with? '/'
  end
  
  attr_reader :path
  
  def each
    return enum_for(:each) unless block_given?
    exercises.each { |exercise| yield exercise }
  end

  def [](name)
    make_exercise(name) # See comment below
  end

  def refresh_cache
    cache = { }
    dir.each_dir do |sub_dir|
      exercise = make_exercise(sub_dir)
      cache[exercise.name] = { :instructions => exercise.instructions }
    end
    dir.write(cache_filename,cache)        
  end
  
private

  def exercises
    @exercises ||= read_cache
  end

  def read_cache
    cache = [ ]
    JSON.parse(read(cache_filename)).each do |name,exercise|
      cache << make_exercise(name,exercise['instructions'])
    end
    cache
  end

  def make_exercise(name,instructions=nil)
    Exercise.new(self,name,instructions)
  end

  def cache_filename
    'cache.json'
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - -
# Refactoring [](name) to...
#
#    exercises.find {|exercise| exercise.name == name}
#
# would be nice since it would make use of the cache in
#    exercises[name].instructions
# but breaks lots of tests because they use DirFake
# without an exercises cache.
# - - - - - - - - - - - - - - - - - - - - - - - -
 
