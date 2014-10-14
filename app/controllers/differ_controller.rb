root = '../..'

require_relative root + '/app/lib/GitDiff'

class DifferController < ApplicationController

  def diff
    diffs = git_diff_view(avatar.tags[was_tag].diff(now_tag))
    current_filename = params[:current_filename]

	render :json => {
	  :lights => avatar.lights.map{|light| light.to_json },
	  :diffs => diffs,
	  :prevAvatar => prevAvatar,
	  :nextAvatar => nextAvatar,
	  :idsAndSectionCounts => prune(diffs),
	  :currentFilenameId => most_changed_file_id(diffs, current_filename)
	}
  end

private

  include GitDiff

  def was_tag
	params[:was_tag].to_i
  end

  def now_tag
	params[:now_tag].to_i
  end

  def active
	avatars.active.map {|avatar| avatar.name}.sort
  end

  def prevAvatar
	names = active
	return '' if names.length == 1
	names.unshift(names.last)
	return names[names.rindex(avatar_name) - 1]
  end

  def nextAvatar
	names = active
	return '' if names.length == 1
	names << names[0]
	return names[names.index(avatar_name) + 1]
  end

  def prune(array)
    # diff-view has been refactored so each diff-view has its own
    # pair of [line-number,content] divs. The filenames are handled
    # separately and only need :id and :section_count entries.
    array.map {|hash| { :id => hash[:id], :section_count => hash[:section_count] } }
  end

end
