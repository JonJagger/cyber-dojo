
module Choose
  
  # When the [setup] button is clicked (on home page) then if
  # there is an id present make the initial selection of the
  # language and the exercise on the setup page the same as the
  # kata with that id - if they still exist.
  
  def self.language(languages, params_id, id, root_dir)
    choice = [*0..languages.length-1].shuffle[0]
    if params_id && Kata.exists?(root_dir, id)
      language_index = languages.index(Kata.new(root_dir, id).language.name)
      if language_index != nil
        choice = language_index;
      end
    end
    choice
  end

  def self.exercise(exercises, params_id, id, root_dir)
    choice = [*0..exercises.length-1].shuffle[0]
    if params_id && Kata.exists?(root_dir, id)
      exercise_index = exercises.index(Kata.new(root_dir, id).exercise.name)
      if exercise_index != nil
        choice = exercise_index
      end
    end
    choice
  end

end
