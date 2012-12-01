require 'GitDiff'

class DiffController < ApplicationController

  include GitDiff
  
  def show
    @kata = Kata.new(root_dir, id)
    @avatar = Avatar.new(@kata, params[:avatar])
    
    @min_tag = 1
    @from_tag = params[:from_tag].to_i
    @to_tag = params[:to_tag].to_i
    @max_tag = @avatar.increments.length    
    @traffic_light = @avatar.increments(@to_tag).last
    
    visible_files = @avatar.visible_files(@to_tag)
    diffed_files = git_diff_view(@avatar, @from_tag, @to_tag, visible_files)    
    @diffs = git_diff_prepare(@avatar, @to_tag, diffed_files)
    if @traffic_lights_to_tag == [ ]
      @current_filename_id = @diffs.find {|diff| diff[:name] == 'instructions'}[:id]
    else
      @current_filename_id = most_changed_lines_file_id(@diffs)
    end
    @title = id[0..4] + ' diff ' + @avatar.name
  end
   
end


