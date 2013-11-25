require 'GitDiff'

class DifferController < ApplicationController
    
  include GitDiff
    
  def diff
    setup_parameters        
    @was_traffic_light = @traffic_lights[@was_tag - 1]
    @now_traffic_light = @traffic_lights[@now_tag - 1]        
    visible_files = @avatar.visible_files(@now_tag)
    diffed_files = git_diff_view(@avatar, @was_tag, @now_tag, visible_files)    
    @diffs = git_diff_prepare(diffed_files)
    @ids_and_section_counts = prune(@diffs)
    @current_filename_id = most_changed_lines_file_id(@diffs, params[:current_filename])    
	
	render :json => {
	  :wasTrafficLight => @was_traffic_light,
	  :nowTrafficLight => @now_traffic_light,
	  :diffs => @diffs,
	  :idsAndSectionCounts => @ids_and_section_counts,
	  :currentFilenameId => @current_filename_id
	}
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
    
  def prune(array)
    # diff-view has been refactored so each diff-view has its own
    # pair of [line-number,content] divs. The filenames are handled
    # separately and only need :id and :section_count entries.
    array.map {|hash| { :id => hash[:id], :section_count => hash[:section_count] } }    
  end

end


