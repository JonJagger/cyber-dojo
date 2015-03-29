
module ExternalExercisesPath # mixin

  def exercises_path
    #external(:exercises_path)
    path = ENV[key]
    path += '/' if !path.end_with? '/'
    path
  end

  def set_exercises_path(path)
    ENV[key] = path
  end
  
private

  def key
    'CYBER_DOJO_EXERCISES_ROOT'
  end

end
