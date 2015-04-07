
class SetupController < ApplicationController

  def show
    p "INSIDE SetupController::show"
    @id = id
    @title = 'create'
    @exercises_names,@instructions = read_exercises        
    @initial_exercise_index = choose_exercise(@exercises_names, id, dojo.katas)    
    languages_names = read_languages
    index = choose_language(languages_names, id, dojo.katas)
    @languages = ::LanguagesDisplayNamesSplitter.new(languages_names, index)
    @initial_language_index = @languages.selected_index
  end

  def save
    language = languages[params['language'] + '-' + params['test']]
    exercise = exercises[params['exercise']]
    kata = katas.create_kata(language, exercise)
    #one_self.created(kata.id, latitude, longtitude)
    render json: { id: kata.id.to_s }
  end

private

  include SetupWorker
  
  def latitude
    Float(params['latitude'].to_s) rescue ''
  end
  
  def longtitude
    Float(params['longtitude'].to_s) rescue ''
  end

end
