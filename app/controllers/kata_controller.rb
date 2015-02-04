
class KataController < ApplicationController

  def edit
    @kata = kata
    @avatar = avatar
    @tab = @kata.language.tab
    @visible_files = @avatar.visible_files

    @new_files = { }
    @filenames_to_delete = [ ]
    @traffic_lights = @avatar.lights
    @output = @visible_files['output']
    @title = 'test:' + @kata.id[0..5] + ':' + @avatar.name
  end

  def run_tests
    @kata   = kata
    @avatar = avatar

    was = params[:file_hashes_incoming]
    now = params[:file_hashes_outgoing]
    delta = FileDeltaMaker.make_delta(was, now)
    visible_files = received_files
    time_limit = 15

    @traffic_lights,@new_files,@filenames_to_delete =
      @avatar.test(delta, visible_files, time_now, time_limit)

    @output = visible_files['output']

    respond_to do |format|
      format.js { render :layout => false }
    end
  end

private

  include Cleaner
  include TimeNow

  def received_files
    seen = { }
    (params[:file_content] || {}).each do |filename,content|
      content = clean(content)
      # Cater for windows line endings from windows browser
      content = content.gsub(/\r\n/, "\n")
      # Cater for jquery-tabby.js plugin
      seen[filename] = MakefileFilter.filter(filename,content)
    end
    seen
  end

end
