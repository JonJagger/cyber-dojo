
module SetupWorker # mixin
  
  include Chooser
  
  def read_languages
    dir = disk[languages.path]
    if dir.exists?(cache_filename)      
      # languages/cache.json is created with languages/cache.rb
      read = JSON.parse(dir.read(cache_filename))
    else
      read = languages.each.select{ |language|
        language.runnable?
      }.map{ |language|
        language.display_name
      }
    end
    read.sort
  end

  def read_exercises
    dir = disk[exercises.path]
    if dir.exists?(cache_filename)
      # exercises/cache.json is created with exercises/cache.rb
      cache = JSON.parse(dir.read(cache_filename)).sort
      exercises_names = cache.map{|one| one[0]}
      instructions = Hash[cache]
    else
      exercises_names = exercises.each.map{ |exercise|
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
