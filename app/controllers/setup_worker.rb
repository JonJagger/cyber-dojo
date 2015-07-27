
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
    # avoid doing exercises[name].instructions as that 
    # currently bypasses the exercises cache
    exercises_names = []
    instructions_hash =  {}
    exercises.each do |exercise|
      exercises_names << exercise.name
      instructions_hash[exercise.name] = exercise.instructions
    end
    [exercises_names,instructions_hash]    
  end

  def cache_filename
    'cache.json'
  end

end
