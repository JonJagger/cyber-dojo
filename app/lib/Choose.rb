
module Choose

  # When the [create] button is clicked (on home page) then if
  # there is an id present make the initial selection of the
  # language and the exercise on the create page the same as the
  # kata with that id - if they still exist.
  # This helps to re-inforce the idea of repetition.

  def self.language(languages, id, katas)
    self.chooser(languages, id, katas) {|kata| kata.language.name}
  end

  def self.exercise(exercises, id, katas)
    self.chooser(exercises, id, katas) {|kata| kata.exercise.name}
  end

  def self.chooser(choices, id, katas)
    choice = [*0..choices.length-1].shuffle[0]
    if katas.valid?(id) && katas[id].exists?
      index = choices.index(yield(katas[id]))
      choice = index if index != nil
    end
    choice
  end

end
