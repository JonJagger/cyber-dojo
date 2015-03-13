
class SetupController < ApplicationController

  def show
    @id = id
    @title = 'create'

    @exercises_names,@instructions = read_exercises        
    @initial_exercise_index = choose_exercise(@exercises_names, id, dojo.katas)
    
    @languages_display_names = read_languages
    index = choose_language(@languages_display_names, id, dojo.katas)
    @split = ::LanguagesDisplayNamesSplitter.new(@languages_display_names, index)
    @initial_language_index = @split.language_selected_index
  end

  def save
    language = dojo.languages[params['language'] + '-' + params['test']]
    exercise = dojo.exercises[params['exercise']]
    kata = dojo.katas.create_kata(language, exercise)
    one_self.created(kata.id, latitude, longtitude)
    render json: { id: kata.id.to_s }
  end

private

  include SetupWorker
  include ExternalOneSelf  
  
  def latitude
    Float(params['latitude'].to_s) rescue ''
  end
  
  def longtitude
    Float(params['longtitude'].to_s) rescue ''
  end

end
