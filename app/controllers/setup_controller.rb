
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
    #event_1self_create_dojo(kata.id) }
    render json: { id: kata.id.to_s }
  end

private

  include SetupWorker

  def event_1self_create_dojo(id)
    stream_id = 'PUXUNZEGWRZUWYRG' # temporary
    read_token = '62713acce800c7bcd75829d16a8aa3e2fb9f2d2daeb0'
    write_token = 'c705e320fd8b9591d27d9579f78fad6ab3a7c0f86078'
    data = {
      'objectTags' => [ 'cyber-dojo' ],
      'actionTags' => [ 'create' ],
      'location' => {
        'lat' => params['latitude'].to_f,
        'long' => params['longtitude'].to_f,
      },
      'properties' => {
        'dojoId' => id
      }
    }
    url = URI.parse("#{one_self_base_url}/#{stream_id}/events")
    http = Net::HTTP.new(url.host)
    header = { 'Content-Type' =>'application/json',
               'Authorization' => "#{write_token}" }
    request = Net::HTTP::Post.new(url.path, header)
    request.body = data.to_json
    response = http.request(request)    
  end

  def one_self_base_url
    'https://api-staging.1self.co/v1/streams'
  end

end
