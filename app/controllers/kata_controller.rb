
class KataController < ApplicationController

  def edit
    @kata = kata
    @avatar = avatar
    @tab = @kata.language.tab
    @visible_files = @avatar.visible_files
    @traffic_lights = @avatar.lights
    @output = @visible_files['output']
    @title = 'test:' + @kata.id[0..5] + ':' + @avatar.name
  end

  def show_json
    # https://atom.io/packages/cyber-dojo
    render :json => {
      'visible_files' => avatar.visible_files,
             'avatar' => avatar.name,
         'csrf_token' => form_authenticity_token,
             'lights' => avatar.lights.map { |light| light.to_json }
    }
  end

  def run_tests
    @kata   = kata
    @avatar = avatar
    incoming = params[:file_hashes_incoming]
    outgoing = params[:file_hashes_outgoing]
    delta = FileDeltaMaker.make_delta(incoming, outgoing)
    visible_files = received_files
    now = time_now
    max_seconds = 15
    traffic_lights,@output = @avatar.test(delta, visible_files, now, max_seconds)
    @rag = traffic_lights[-1]['colour']

    respond_to do |format|
      format.js   { render layout: false }
      format.json { show_json }
    end
  end

  private

  include MakefileFilter
  include StringCleaner
  include TimeNow

  def received_files
    seen = {}
    (params[:file_content] || {}).each do |filename,content|
      content = clean(content)
      # Cater for windows line endings from windows browser
      content = content.gsub(/\r\n/, "\n")
      seen[filename] = makefile_filter(filename, content)
    end
    seen
  end

end
