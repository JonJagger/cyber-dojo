
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
    time_limit = 15
    @traffic_lights,@output = @avatar.test(delta, visible_files, now, time_limit)
    @cyber_dojo_sh = visible_files['cyber-dojo.sh']

    # Turn this off as it is somehow causing errors when the
    # cyber-dojo.sh and output files are updated.
    #
    #tag = @traffic_lights.length
    #diffed_files = avatar.diff(tag-1,tag)
    #hash = {
    #  :tag => tag,
    #  :colour => @traffic_lights[-1]['colour'],
    #  :now => now,
    #  :added_line_count  => added_line_count(diffed_files),
    #  :deleted_line_count => deleted_line_count(diffed_files),
    #  :seconds_since_last_test => seconds_since_last_test(avatar,tag)
    #}
    #one_self.tested(@avatar,hash)

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

  #def added_line_count(diffed_files)
  #  count = 0
  #  diffed_files.each do |filename,diff|
  #    if filename != 'output'
  #      count += diff.count { |line| line[:type] == :added   }
  #    end
  #  end
  #  count
  #end

  #def deleted_line_count(diffed_files)
  #  count = 0
  #  diffed_files.each do |filename,diff|
  #    if filename != 'output'
  #      count += diff.count { |line| line[:type] == :deleted }
  #    end
  #  end
  #  count
  #end

  #def seconds_since_last_test(avatar,tag)
  #  (avatar.tags[tag].time - avatar.tags[tag-1].time).to_i
  #end

end
