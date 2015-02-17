
class Setup2Controller < ApplicationController

  def show
    @languages,languages_names = read_languages
    @exercises_names,@instructions = read_exercises
    
    @languages_display_names = @languages.map{|array| array[0]}
    
    @selected_language_index = choose_language2(@languages_display_names, id, dojo.katas)
    @selected_exercise_index = choose_exercise(@exercises_names, id, dojo.katas)
    @id = id
    @title = 'create'
    
    @split = ::LanguagesDisplayNamesSplitter.new(@languages_display_names, @selected_language_index)
    @selected_language_index = @split.language_selected_index        
  end

  def save
    language = dojo.languages[params['language'] + '-' + params['test']]
    exercise = dojo.exercises[params['exercise']]
    kata = dojo.katas.create_kata(language, exercise)
    render :json => {
      :id => kata.id.to_s
    }
  end

private

  include ExternalDiskDir
  include Chooser
  
  def read_languages
    dir = disk[dojo.languages.path]
    if dir.exists?(cache_filename)
      # languages/cache.json is created with languages/cache.rb
      languages = JSON.parse(dir.read(cache_filename)).sort
    else
      languages = dojo.languages.each.select{ |language|
        language.runnable?
      }.map{ |language|
        [language.display_name,language.name]
      }.sort
    end
    languages_names = languages.map{|array| array[1]}
    
    [languages,languages_names]
  end

  def read_exercises
    dir = disk[dojo.exercises.path]
    if dir.exists?(cache_filename)
      # exercises/cache.json is created with exercises/cache.rb
      cache = JSON.parse(dir.read(cache_filename)).sort
      exercises_names = cache.map{|one| one[0]}
      instructions = Hash[cache]
    else
      exercises_names = dojo.exercises.each.map{ |exercise|
        exercise.name
      }.sort
      instructions = Hash[exercises_names.collect{ |name|
        [name, dojo.exercises[name].instructions]
      }]
    end
    [exercises_names,instructions]
  end

  def cache_filename
    'cache.json'
  end

end
