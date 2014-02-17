
module Choose
  
  # When the [setup] button is clicked (on home page) then if
  # there is an id present make the initial selection of the
  # language and the exercise on the setup page the same as the
  # kata with that id - if they still exist.
  
  #TODO: put these two methods in app/models/Cyber_Dojo
  
  def self.language(languages, params_id, id, root_dir)
    cd = Cyber_Dojo.new(root_dir)
    kata = cd[id]
    choice = [*0..languages.length-1].shuffle[0]
    if params_id && kata.exists?
      language_index = languages.index(kata.language.name)
      if language_index != nil
        choice = language_index;
      end
    end
    choice
  end

  def self.exercise(exercises, params_id, id, root_dir)
    cd = Cyber_Dojo.new(root_dir)
    kata = cd[id]    
    choice = [*0..exercises.length-1].shuffle[0]
    if params_id && kata.exists?
      exercise_index = exercises.index(kata.exercise.name)
      if exercise_index != nil
        choice = exercise_index
      end
    end
    choice
  end

end
