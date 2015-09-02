
# When the [create] button is clicked (on home page) then if
# there is an id present make the initial selection of the
# language and the exercise on the create page the same as the
# kata with that id - if it still exists.
# This helps to re-inforce the idea of repetition.

module Chooser # mixin

  module_function

  def choose_language(languages, id, katas)
    chooser(languages, id, katas) { |kata| kata.language.display_name }
  end

  def choose_exercise(exercises, id, katas)
    chooser(exercises, id, katas) { |kata| kata.exercise.name }
  end

  def chooser(choices, id, katas)
    choice = [*0...choices.length].shuffle[0]
    if katas.exists?(id)
      index = choices.index(yield(katas[id]))
      choice = index if !index.nil?
    end
    choice
  end

end
