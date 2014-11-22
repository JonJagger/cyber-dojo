
class SetupController < ApplicationController

  def show
    read_all_languages
    read_from_exercises_manifest || read_all_exercises
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

  def read_all_languages
    @languages = dojo.languages.select{|language| language.runnable?}.map{|language|
      [language.name,language.display_name]
    }.sort
    @languages_names = @languages.map{|array| array[0]}
  end

  def read_from_exercises_manifest
    dir = @disk[dojo.exercises.path]
    # manifest is created with cyber-dojo/exercises/cache.rb
    if dir.exists?(manifest_filename)
      manifest = JSON.parse(dir.read(manifest_filename)).sort
      @exercises_names = manifest.map{|one| one[0]}
      @instructions = { }
      manifest.each do |one|
        @instructions[one[0]] = one[1]
      end
      return true
    end
    return false
  end

  def read_all_exercises
    @exercises_names = dojo.exercises.map{|exercise| exercise.name}.sort
    @instructions = { }
    @exercises_names.each do |name|
      @instructions[name] = dojo.exercises[name].instructions
    end
  end

  def manifest_filename
    'manifest.json'
  end

end
