root = '../..'

require_relative root + '/app/lib/Chooser'

class SetupController < ApplicationController

  def show
    @languages = dojo.languages.select{|language| language.runnable?}.map{|language|
      [language.display_name,language.display_test_name,language.name]
    }.sort
    @languages_names = @languages.map{|array| array[2]}
    @exercises_names = dojo.exercises.map{|exercise| exercise.name}.sort
    @instructions = { }
    @exercises_names.each do |name|
      @instructions[name] = dojo.exercises[name].instructions
    end
    @selected_language_index = choose_language(@languages_names, id, dojo.katas)
    @selected_exercise_index = choose_exercise(@exercises_names, id, dojo.katas)
    @id = id
    @title = 'Create'
  end

  def save
    language = dojo.languages[params['language']]
    exercise = dojo.exercises[params['exercise']]
    kata = dojo.katas.create_kata(language, exercise)
    render :json => {
      :id => kata.id.to_s
    }
  end

private

  include Chooser

end
