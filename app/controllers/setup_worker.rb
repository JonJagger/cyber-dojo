
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
    exercises_names = exercises.map{ |exercise|
      exercise.name
    }.sort
    instructions = Hash[exercises_names.collect{ |name|
      [name, exercises[name].instructions]
    }]
    [exercises_names,instructions]
  end

  def cache_filename
    'cache.json'
  end

end
