
class DifferController < ApplicationController

  def diff
    diffs = git_diff_view(avatar.tags[was_tag].diff(now_tag))

	render :json => {
	  :lights => avatar.lights.map{|light| light.to_json },
	  :diffs => diffs,
	  :prevAvatar => prevAvatar,
	  :prevAvatarMaxTag => maxTag(prevAvatar),
	  :nextAvatar => nextAvatar,
	  :nextAvatarMaxTag => maxTag(nextAvatar),
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

  def current_filename
    params[:current_filename]
  end

  def active_avatar_names
	avatars.active.map {|avatar| avatar.name}.sort
  end

  def prevAvatar
	names = active_avatar_names
	return '' if names.length == 1
	names.unshift(names.last)
	return names[names.rindex(avatar_name) - 1]
  end

  def nextAvatar
	names = active_avatar_names
	return '' if names.length == 1
	names << names[0]
	return names[names.index(avatar_name) + 1]
  end

  def maxTag(avatar_name)
    return 0 if avatar_name === ''
    return avatars[avatar_name].lights.length
  end

  def prune(array)
    # diff-view has been refactored so each diff-view has its own
    # pair of [line-number,content] divs. The filenames are handled
    # separately and only need :id and :section_count entries.
    array.map {|hash| { :id => hash[:id], :section_count => hash[:section_count] } }
  end

end
