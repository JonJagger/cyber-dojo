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
      @outcome = ''
      @current_filename_id = @diffs.find {|diff| diff[:name] == 'instructions'}[:id]
    else
      @outcome = @traffic_lights_to_tag.last[:outcome]
      @current_filename_id = most_changed_lines_file_id(@diffs)
    end
    @title = 'Diff'
  end
   
  def fork
    kata = Kata.new(root_dir, params['id'])
    params['language'] = kata.language.name
    params['exercise'] = kata.exercise.name
    info = gather_info
    info[:diff_id] = params['id']
    info[:diff_language] = params['language']
    info[:diff_exercise] = params['exercise']
    info[:diff_avatar] = params['avatar']
    info[:diff_tag] = params['tag']      
        
    kata = Kata.new(root_dir, info[:diff_id])
    avatar = Avatar.new(kata, info[:diff_avatar])
    info[:visible_files] = avatar.visible_files(info[:diff_tag])
    
    Kata.create_new(root_dir, info)
    
    redirect_to :controller => :dojo,
                :action => :index, 
                :id => info[:id]
  end
   
end


