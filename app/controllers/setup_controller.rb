
class SetupController < ApplicationController

  def show_languages_and_tests
    @id = id
    @title = 'create'
    languages_names = read_languages
    index = choose_language(languages_names, id, dojo.katas)
    @languages = ::LanguagesDisplayNamesSplitter.new(languages_names, index)
    @initial_language_index = @languages.selected_index
  end

  def show_exercises
    @id = id
    @title = 'create'
    @language = params[:language]
    @test = params[:test]
    @exercises_names,@instructions = read_exercises
    @initial_exercise_index = choose_exercise(@exercises_names, id, dojo.katas)
  end

  def save
    language_name = params['language']
        test_name = params['test'    ]
    exercise_name = params['exercise']
    language = languages[language_name + '-' + test_name]
    exercise = exercises[exercise_name]
    kata = history.create_kata(language, exercise)
    render json: { id: kata.id }
  end

  private

  include SetupChooser
  include SetupWorker

end
