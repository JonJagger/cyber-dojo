
module SetupWorker # mix-in

  module_function

  def read_languages
    runner.runnable_languages.map { |language| language.display_name }.sort
  end

  def read_exercises
    exercises_names = []
    instructions_hash =  {}
    exercises.each do |exercise|
      exercises_names << exercise.name
      instructions_hash[exercise.name] = exercise.instructions
    end
    [exercises_names.sort, instructions_hash]
  end

end
