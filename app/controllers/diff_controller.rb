require 'GitDiff'

class DiffController < ApplicationController

  include GitDiff
  
  def show
    setup_parameters        
    @was_traffic_light = @traffic_lights[@was_tag - 1]
    @now_traffic_light = @traffic_lights[@now_tag - 1]        
    visible_files = @avatar.visible_files(@now_tag)
    diffed_files = git_diff_view(@avatar, @was_tag, @now_tag, visible_files)    
    @diffs = git_diff_prepare(diffed_files)    
    @current_filename_id = most_changed_lines_file_id(@diffs, params[:current_filename])    
    @title = id[0..4] + ' ' + @avatar.name + ' ' + 'diff' 
  end
   
  def heartbeat
    setup_parameters    
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def help_dialog
    @avatar_name = params[:avatar_name]
    render :layout => false
  end
  
private

  def setup_parameters
    @kata = Kata.new(root_dir, id)    
    @avatar = Avatar.new(@kata, params[:avatar])
    @traffic_lights = @avatar.traffic_lights    
    @min_tag = 0
    @was_tag = params[:was_tag].to_i
    @now_tag = params[:now_tag].to_i
    @max_tag = @traffic_lights.length
  end
  
end


