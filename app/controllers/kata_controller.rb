
require 'Approval'
require 'FileDeltaMaker'
require 'MakefileFilter'
require 'OutputParser'

class KataController < ApplicationController

  def edit
    @kata = dojo.katas[id]
    @avatar = @kata.avatars[params[:avatar]]
    @tab = @kata.language.tab
    @visible_files = @avatar.tags.latest.visible_files
    @new_files = { }
    @files_to_remove = [ ]
    @traffic_lights = @avatar.lights.each.entries
    @output = @visible_files['output']
    @title = id[0..5] + ' ' + @avatar.name + ' code'
  end

  def run_tests
    @kata   = dojo.katas[id]
    @avatar = @kata.avatars[params[:avatar]]
    visible_files = received_files
    previous_filenames = visible_files.keys
    visible_files.delete('output')

    was = params[:file_hashes_incoming]
    now = params[:file_hashes_outgoing]
    delta = FileDeltaMaker.make_delta(was, now)
    # there are a lot of steps below that should be collapsed somewhat.
    @avatar.save(delta, visible_files)
    max_duration = 15
    @output = @avatar.test(max_duration)
    @avatar.sandbox.write('output', @output) # so output appears in diff-view
    visible_files['output'] = @output
    traffic_light = OutputParser::parse(@kata.language.unit_test_framework, @output)
    @traffic_lights = @avatar.save_traffic_light(traffic_light, make_time(Time.now))

    #should really only do this if kata is using approval-style test-framework
    Approval::add_text_files_created_in_run_tests(@avatar.sandbox.path, visible_files)
    Approval::delete_text_files_deleted_in_run_tests(@avatar.sandbox.path, visible_files)

    @avatar.save_manifest(visible_files)
    @avatar.commit(@traffic_lights.length)

    @new_files = visible_files.select {|filename, content| ! previous_filenames.include?(filename)}
    @files_to_remove = previous_filenames.select {|filename| ! visible_files.keys.include?(filename)}

    respond_to do |format|
      format.js if request.xhr?
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
      content = clean(content)
      # Cater for windows line endings from windows browser
      content = content.gsub(/\r\n/, "\n")
      # Cater for jquery-tabby.js plugin
      seen[filename] = MakefileFilter.filter(filename,content)
    end
    seen
  end

  def clean(s)
    s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    s = s.encode('UTF-8', 'UTF-16')
  end

end
