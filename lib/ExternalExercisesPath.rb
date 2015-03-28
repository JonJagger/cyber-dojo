
module ExternalExercisesPath # mixin

  def exercises_path
    #external(:exercises_path)
    path = ENV['CYBER_DOJO_EXERCISES_ROOT']
    path += '/' if !path.end_with? '/'
    path
  end

private

  #include External

end
