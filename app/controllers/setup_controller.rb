
class SetupController < ApplicationController

  def show
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
    language = languages[language_name] + '-' + test_name]
    exercise = exercises[exercise]
    kata = katas.create_kata(language, exercise)
    hash = {
      :kata_id => kata.id,
      :language_name => language_name,
      :test_name => test_name,
      :latitude => latitude,
      :longtitude => longtitude
    }
    one_self.created(hash)
    render json: { id: kata.id.to_s }
  end

private

  include SetupWorker

  def language_name
    params['language']
  end
  
  def test_name
    params['test']
  end
  
  def exercise_name
    params['exercise']
  end
  
  def latitude
    Float(params['latitude'].to_s) rescue ''
  end
  
  def longtitude
    Float(params['longtitude'].to_s) rescue ''
  end

end
