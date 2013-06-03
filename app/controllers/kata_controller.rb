
require 'CodeOutputParser'

class KataController < ApplicationController
    
  def edit
    @kata = Kata.new(root_dir, id)
    @avatar = Avatar.new(@kata, params[:avatar])
    @tab = @kata.language.tab    
    @visible_files = @avatar.visible_files
    @new_files = {}
    @files_to_remove = []
    @traffic_lights = @avatar.increments
    @output = @visible_files['output']
    @title = id[0..4] + ' ' + @avatar.name + ' code' 
  end

  def run_tests
    @kata = Kata.new(root_dir, id)
    @avatar = Avatar.new(@kata, params[:avatar])
    language = @kata.language
    sandbox = Sandbox.new(root_dir, id, params[:avatar])
    visible_files = received_files
    previous_files = visible_files.keys
    @output = sandbox.run(language, visible_files)
    inc = CodeOutputParser::parse(language.unit_test_framework, @output)
    inc[:revert_tag] = params[:revert_tag]    
    @traffic_lights = @avatar.save_run_tests(visible_files, @output, inc)

    @new_files = @avatar.visible_files.select {|filename, content| ! previous_files.include?(filename)}
    @files_to_remove = previous_files.select {|filename| ! @avatar.visible_files.keys.include?(filename)}
    @visible_files = @avatar.visible_files

    respond_to do |format|
      format.js if request.xhr?
    end      
  end
      
  def help_dialog
    @avatar_name = params[:avatar_name]
    respond_to do |format|
      format.json {
        render :json => {
          :html => bind('/app/views/kata/help_dialog.html.erb'),
          :size => 550
        }
      }
    end
  end
      
  def fork_dialog
    respond_to do |format|
      format.json {
        render :json => {
          :html => bind('/app/views/kata/fork_dialog.html.erb'),
          :title => 'fork'
        }
      }
    end
  end
  
private

  def received_files
    seen = { }
    (params[:file_content] || {}).each do |filename,content|
      # Cater for windows line endings from windows browser
      seen[dequote(filename)] = content.gsub(/\r\n/, "\n")  
    end
    seen
  end

  def dequote(filename)
    # <input name="file_content['wibble.h']" ...>
    # means filename has a leading ' and trailing '
    # which need to be stripped off
    return filename[1..-2] 
  end

end


