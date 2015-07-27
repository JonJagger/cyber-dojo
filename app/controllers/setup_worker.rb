
module SetupWorker # mixin
  
  include Chooser
  
  def read_languages
      languages.select{ |language|
        language.runnable?
      }.map{ |language|
        language.display_name
      }.sort
  end

  def read_exercises
    dir = disk[exercises.path]
    if dir.exists?(cache_filename)
      # exercises/cache.json is created with exercises/cache.rb
      cache = JSON.parse(dir.read(cache_filename)).sort
      exercises_names = cache.map{|one| one[0]}
      instructions = Hash[cache]
    else
      exercises_names = exercises.map{ |exercise|
        exercise.name
      }.sort
      instructions = Hash[exercises_names.collect{ |name|
        [name, exercises[name].instructions]
      }]
    end
    [exercises_names,instructions]
  end

  def cache_filename
    'cache.json'
  end

end
