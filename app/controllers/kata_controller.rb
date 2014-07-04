root = '../..'

require_relative root + '/app/lib/Approval'
require_relative root + '/app/lib/Cleaner'
require_relative root + '/app/lib/FileDeltaMaker'
require_relative root + '/app/lib/MakefileFilter'
require_relative root + '/lib/TimeNow'

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
    was = params[:file_hashes_incoming]
    now = params[:file_hashes_outgoing]
    delta = FileDeltaMaker.make_delta(was, now)

    visible_files = received_files
    pre_test_filenames = visible_files.keys

    @kata   = dojo.katas[id]
    @avatar = @kata.avatars[params[:avatar]]

    max_duration = 15
    now = time_now
    @traffic_lights = @avatar.test(delta, visible_files, max_duration, now)
    @output = visible_files['output']

    #should really only do this if kata is using approval-style test-framework
    Approval::add_created_txt_files(@avatar.sandbox.path, visible_files)
    Approval::remove_deleted_txt_files(@avatar.sandbox.path, visible_files)

    @avatar.save_manifest(visible_files)
    @avatar.commit(@traffic_lights.length)

    @new_files = visible_files.select {|filename,_| ! pre_test_filenames.include?(filename)}
    @files_to_remove = pre_test_filenames.select {|filename| ! visible_files.keys.include?(filename)}

    respond_to do |format|
      format.js if request.xhr?
    end
  end

  def help_dialog
    @avatar_name = params[:avatar_name]
    render :layout => false
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
