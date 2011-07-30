require 'Ids'
require 'GitDiff'

class DiffController < ApplicationController

  include Ids
  include GitDiff
  
  def show
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    tag = params[:tag].to_i
    @traffic_lights_to_tag = @avatar.increments(tag)
    @all_traffic_lights = @avatar.increments   
    diffed_files = git_diff_view(@avatar, tag)    
    @diffs = git_diff_prepare(diffed_files)    
    @current_filename_id = most_changed_lines_file_id(@diffs)
  end
   
end


