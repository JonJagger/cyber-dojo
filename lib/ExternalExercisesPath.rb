
module ExternalExercisesPath # mixin

  def exercises_path
    external(:exercises_path)
  end

private

  include External

end
