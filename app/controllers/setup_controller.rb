
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
    language_name = params['language']
        test_name = params['test'    ]
    exercise_name = params['exercise']
    language = languages[language_name + '-' + test_name]
    exercise = exercises[exercise_name]
    kata = katas.create_kata(language, exercise)
    one_self_created(language_name, test_name, exercise_name, kata.id, time_now)
    render json: { id: kata.id }
  end

  private

  include SetupChooser
  include SetupWorker
  include TimeNow

  def one_self_created(language_name, test_name, exercise_name, id, now)
    latitude   = Float(params['latitude'  ].to_s) rescue ''
    longtitude = Float(params['longtitude'].to_s) rescue ''
    hash = {
            kata_id: id,
                now: now,
      language_name: language_name,
          test_name: test_name,
      exercise_name: exercise_name,
           latitude: latitude,
         longtitude: longtitude
    }
    one_self.created(hash)
  end

end
