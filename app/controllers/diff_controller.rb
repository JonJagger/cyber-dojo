require 'Ids'
require 'GitDiff'

class DiffController < ApplicationController

  include Ids
  include GitDiff
  
  def show
    configure(params)
    @kata = Kata.new(params)
    @avatar = Avatar.new(@kata, params[:avatar])
    tag = params[:tag].to_i
    @traffic_lights_to_tag = @avatar.increments(tag)
    @all_traffic_lights = @avatar.increments
    visible_files = @avatar.visible_files(tag)
    diffed_files = git_diff_view(@avatar, tag, visible_files)    
    @diffs = git_diff_prepare(diffed_files)
    if @traffic_lights_to_tag == [ ]
      @outcome = ''
      @current_filename_id = @diffs.find {|diff| diff[:name] == 'instructions'}[:id]
    else
      @outcome = @traffic_lights_to_tag.last[:outcome]
      @current_filename_id = most_changed_lines_file_id(@diffs)
    end
    @tab_title = 'Diff View'
  end
   
end


