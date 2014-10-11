root = '../..'

require_relative root + '/app/lib/GitDiff'

class DifferController < ApplicationController

  def diff
	avatars = dojo.katas[id].avatars
    avatar = avatars[avatar_name]
    diffs = git_diff_view(avatar.tags[was_tag].diff(now_tag))
    current_filename = params[:current_filename]

	render :json => {
	  :lights => avatar.lights.map{|light| light.to_json },
      :visibleFiles => avatar.tags[now_tag].visible_files,
	  :diffs => diffs,
	  :prevAvatar => 'snake',
	  :nextAvatar => 'wolf',
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

  def avatar_name
	params[:avatar]
  end

  def prune(array)
    # diff-view has been refactored so each diff-view has its own
    # pair of [line-number,content] divs. The filenames are handled
    # separately and only need :id and :section_count entries.
    array.map {|hash| { :id => hash[:id], :section_count => hash[:section_count] } }
  end

end
