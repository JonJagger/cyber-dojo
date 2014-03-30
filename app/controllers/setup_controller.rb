
require 'Choose'

class SetupController < ApplicationController

  def show
    paas.session('setup:show') do
      @languages = dojo.languages.map{|language|
        [language.display_name,language.display_unit_test_framework,language.name]
      }.sort
      @languages_names = @languages.map{|array| array[2]}
      @exercises_names = dojo.exercises.map{|exercise| exercise.name}.sort
      @instructions = { }
      @exercises_names.each do |name|
        @instructions[name] = dojo.exercises[name].instructions
      end
      # Choose:: not refactored for Docker yet...
      @selected_language_index = Choose::language(@languages_names, params[:id], id, dojo)
      @selected_exercise_index = Choose::exercise(@exercises_names, params[:id], id, dojo)
      @id = id
      @title = 'Setup'
    end
  end

  def save
    paas.session('setup:save') do
      language = dojo.languages[params['language']]
      exercise = dojo.exercises[params['exercise']]
      kata = dojo.make_kata(language, exercise)
      render :json => {
        :id => kata.id.to_s
      }
    end
  end

end
