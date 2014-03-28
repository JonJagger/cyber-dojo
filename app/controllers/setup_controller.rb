
require 'Choose'

class SetupController < ApplicationController

  def show
    @languages = dojo.languages.map{|language|
      [language.display_name,language.display_unit_test_framework,language.name]
    }.sort
    @languages_names = @languages.map{|array| array[2]}
    @exercises_names = dojo.exercises.map{|exercise| exercise.name}.sort
    @instructions = { }
    @exercises_names.each do |name|
      @instructions[name] = dojo.exercises[name].instructions
    end
    @selected_language_index = Choose::language(@languages_names, params[:id], id, dojo)
    @selected_exercise_index = Choose::exercise(@exercises_names, params[:id], id, dojo)
    @id = id
    @title = 'Setup'
  end

  def save
    language = dojo.languages[params['language']]
    exercise = dojo.exercises[params['exercise']]
    kata = dojo.make_kata(language, exercise)

    logger.info("Created dojo " + kata.id.to_s +
                ", " + language.name +
                ", " + exercise.name +
                ", " + make_time(Time.now).to_s)

    render :json => {
      :id => kata.id.to_s
    }
  end

end
