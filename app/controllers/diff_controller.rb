require 'GitDiff'

class DiffController < ApplicationController

  include GitDiff
  
  def show
    @kata = Kata.new(root_dir, id)
    @avatar = Avatar.new(@kata, params[:avatar])
    tag = params[:tag].to_i
    @traffic_lights_to_tag = @avatar.increments(tag)
    @all_traffic_lights = @avatar.increments
    visible_files = @avatar.visible_files(tag)
    diffed_files = git_diff_view(@avatar, tag, visible_files)    
    @diffs = git_diff_prepare(@avatar, tag, diffed_files)
    if @traffic_lights_to_tag == [ ]
      @current_filename_id = @diffs.find {|diff| diff[:name] == 'instructions'}[:id]
    else
      @current_filename_id = most_changed_lines_file_id(@diffs)
    end
    @title = id[0..4] + ' diff ' + @avatar.name
  end
   
  def fork
    kata = Kata.new(root_dir, params['id'])
    params['language'] = kata.language.name
    params['exercise'] = kata.exercise.name
    avatar = Avatar.new(kata, params['avatar'])

    info = gather_info
    info[:visible_files] = avatar.visible_files(info[:tag])    
    Kata.create_new(root_dir, info)
    
    redirect_to :controller => :dojo,
                :action => :index, 
                :id => info[:id]
  end
   
end


