
class SetupController < ApplicationController

  def show
    read_languages
    read_exercises
    @selected_language_index = choose_language(@languages_names, id, dojo.katas)
    @selected_exercise_index = choose_exercise(@exercises_names, id, dojo.katas)
    @id = id
    @title = 'create'
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

  def read_languages
    dir = disk[dojo.languages.path]
    if dir.exists?(cache_filename)
      # cache.json is created with cyber-dojo/languages/cache.rb
      @languages = JSON.parse(dir.read(cache_filename)).sort
    else
      @languages = dojo.languages.select{|language| language.runnable?}.map{|language|
        [language.name,language.display_name]
      }.sort
    end
    @languages_names = @languages.map{|array| array[0]}
  end

  def read_exercises
    dir = disk[dojo.exercises.path]
    if dir.exists?(cache_filename)
      # cache.json is created with cyber-dojo/exercises/cache.rb
      cache = JSON.parse(dir.read(cache_filename)).sort
      @exercises_names = cache.map{|one| one[0]}
      @instructions = { }
      cache.each do |one|
        @instructions[one[0]] = one[1]
      end
    else
      @exercises_names = dojo.exercises.map{|exercise| exercise.name}.sort
      @instructions = { }
      @exercises_names.each do |name|
        @instructions[name] = dojo.exercises[name].instructions
      end
    end
  end

  def cache_filename
    'cache.json'
  end

end
