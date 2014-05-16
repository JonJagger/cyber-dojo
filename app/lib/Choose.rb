
module Choose

  # When the [create] button is clicked (on home page) then if
  # there is an id present make the initial selection of the
  # language and the exercise on the create page the same as the
  # kata with that id - if they still exist.
  # This helps to re-inforce the idea of repetition.

  def self.language(languages, params_id, kata)
    self.chooser(languages, params_id, kata) {|kata| kata.language.name}
  end

  def self.exercise(exercises, params_id, kata)
    self.chooser(exercises, params_id, kata) {|kata| kata.exercise.name}
  end

  def self.chooser(choices, params_id, kata)
    choice = [*0..choices.length-1].shuffle[0]
    if params_id && kata.exists?
      index = choices.index(yield(kata))
      if index != nil
        choice = index
      end
    end
    choice
  end

end
