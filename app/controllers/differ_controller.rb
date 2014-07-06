root = '../..'

require_relative root + '/app/lib/GitDiff'

class DifferController < ApplicationController

  def diff
    setup_parameters
    @was_traffic_light = @traffic_lights[@was_tag - 1]
    @now_traffic_light = @traffic_lights[@now_tag - 1]

    visible_files = @avatar.tags[@now_tag].visible_files
    diff_lines = @avatar.tags[@was_tag].diff(@now_tag)
    diffed_files = git_diff(diff_lines, visible_files)
    @diffs = git_diff_view(diffed_files)
    @ids_and_section_counts = prune(@diffs)
    @current_filename_id = most_changed_file_id(@diffs, @current_filename)

	render :json => {
	  :wasTrafficLight => @was_traffic_light,
	  :nowTrafficLight => @now_traffic_light,
	  :diffs => @diffs,
	  :idsAndSectionCounts => @ids_and_section_counts,
	  :currentFilenameId => @current_filename_id
	}
  end

private

  include GitDiff

  def setup_parameters
    @kata = dojo.katas[id]
    @avatar = @kata.avatars[params[:avatar]]
    @traffic_lights = @avatar.lights.each.entries
    @min_tag = 0
    @was_tag = params[:was_tag].to_i
    @now_tag = params[:now_tag].to_i
    @max_tag = @traffic_lights.length
    @current_filename = params[:current_filename]
  end

  def prune(array)
    # diff-view has been refactored so each diff-view has its own
    # pair of [line-number,content] divs. The filenames are handled
    # separately and only need :id and :section_count entries.
    array.map {|hash| { :id => hash[:id], :section_count => hash[:section_count] } }
  end

end
