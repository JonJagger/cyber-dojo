
module ExternalExercisesPath # mixin

  def exercises_path?
    !ENV[exercises_key].nil?
  end

  def exercises_path
    path = ENV[exercises_key]
    path += '/' if !path.end_with? '/'
    path
  end

  def set_exercises_path(path)
    ENV[exercises_key] = path
  end
  
private

  def exercises_key
    'CYBER_DOJO_EXERCISES_ROOT'
  end

end
