
require 'Choose'

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
    kata = dojo.katas[id]
    @selected_language_index = Choose::language(@languages_names, params[:id], kata)
    @selected_exercise_index = Choose::exercise(@exercises_names, params[:id], kata)
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

end
