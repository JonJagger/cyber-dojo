
require 'Approval'
require 'OutputParser'
require 'FileDeltaMaker'
require 'MakefileFilter'

class KataController < ApplicationController

  def edit
    paas.session('kata:edit') do
      @kata = dojo.katas[id]
      @avatar = @kata.avatars[params[:avatar]]
      @tab = @kata.language.tab
      @visible_files = @avatar.visible_files
      @new_files = { }
      @files_to_remove = [ ]
      @traffic_lights = @avatar.traffic_lights
      @output = @visible_files['output']
      @title = id[0..5] + ' ' + @avatar.name + ' code'
    end
  end

  def run_tests
    paas.session('kata:run_tests') do
      @kata   = dojo.katas[id]
      @avatar = @kata.avatars[params[:avatar]]
      visible_files = received_files
      previous_files = visible_files.keys # should be previous_filenames
      visible_files.delete('output')

      was = params[:file_hashes_incoming]
      now = params[:file_hashes_outgoing]
      delta = FileDeltaMaker.make_delta(was, now)
      # there are a lot of steps below that could be collapsed into one
      # command. I don't do that because later on I am going to need to
      # convert old format katas to new format katas which means I will
      # need to miss out the step that does the actual test()
      @avatar.save(delta, visible_files)
      @output = @avatar.test()
      @avatar.sandbox.write('output', @output) # so output appears in diff-view
      visible_files['output'] = @output

      #should really only do this if kata is using approval-style test-framework
      Approval::add_text_files_created_in_run_tests(@paas.path(@avatar.sandbox), visible_files)
      Approval::delete_text_files_deleted_in_run_tests(@paas.path(@avatar.sandbox), visible_files)

      @avatar.save_visible_files(visible_files)
      traffic_light = OutputParser::parse(@kata.language.unit_test_framework, @output)
      @traffic_lights = @avatar.save_traffic_light(traffic_light, make_time(Time.now))
      @avatar.commit(@traffic_lights.length)

      @new_files = visible_files.select {|filename, content| ! previous_files.include?(filename)}
      @files_to_remove = previous_files.select {|filename| ! visible_files.keys.include?(filename)}

      respond_to do |format|
        format.js if request.xhr?
      end
    end
  end

  def help_dialog
    @avatar_name = params[:avatar_name]
    render :layout => false
  end

private

  def received_files
    seen = { }
    (params[:file_content] || {}).each do |filename,content|
      # Cater for windows line endings from windows browser
      content = content.gsub(/\r\n/, "\n")
      # Cater for jquery-tabby.js plugin
      seen[filename] = MakefileFilter.filter(filename,content)
    end
    seen
  end

end
