
class SetupController < ApplicationController

  def show
    @id = id
    @title = 'create'

    @languages,languages_names = read_languages
    @exercises_names,@instructions = read_exercises
        
    @languages_display_names = @languages.map{|array| array[0]}
    @initial_language_index = choose_language(@languages_display_names, id, dojo.katas)
    @initial_exercise_index = choose_exercise(@exercises_names, id, dojo.katas)    
    @split = ::LanguagesDisplayNamesSplitter.new(@languages_display_names, @initial_language_index)
    @initial_language_index = @split.language_selected_index
  end

  def save
    language = dojo.languages[params['language'] + '-' + params['test']]
    exercise = dojo.exercises[params['exercise']]
    kata = dojo.katas.create_kata(language, exercise)
    latitude = params['latitude'].to_f
    longtitude = params['longtitude'].to_f
    #one_self.created(kata.id, latitude, longtitude)
    render json: { id: kata.id.to_s }
  end

private

  include SetupWorker
  include ExternalOneSelf  

end
