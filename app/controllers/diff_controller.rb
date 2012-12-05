require 'GitDiff'

class DiffController < ApplicationController

  include GitDiff
  
  def show
    @kata = Kata.new(root_dir, id)
    @avatar = Avatar.new(@kata, params[:avatar])
    traffic_lights = @avatar.increments    
    
    @min_tag = 1
    @was_tag = params[:was_tag].to_i
    @now_tag = params[:now_tag].to_i
    @max_tag = traffic_lights.length
    
    @was_traffic_light = traffic_lights[@was_tag-1]
    @now_traffic_light = traffic_lights[@now_tag-1]
        
    visible_files = @avatar.visible_files(@now_tag)
    diffed_files = git_diff_view(@avatar, @was_tag, @now_tag, visible_files)    
    @diffs = git_diff_prepare(@avatar, @now_tag, diffed_files)
    if traffic_lights == [ ]
      @current_filename_id = @diffs.find {|diff| diff[:name] == 'instructions'}[:id]
    else
      @current_filename_id = most_changed_lines_file_id(@diffs)
    end
    @title = id[0..4] + ' diff ' + @avatar.name
  end
   
end


