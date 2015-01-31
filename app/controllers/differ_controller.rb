
class DifferController < ApplicationController

  def diff
    @lights = avatar.lights.map{|light| light.to_json }
    diffs = git_diff_view(avatar.tags[was_tag].diff(now_tag))
	render :json => {
	  :lights => @lights,
	  :diffs => diffs,
	  :prevAvatar => prev_avatar,
	  :nextAvatar => next_avatar,
	  :idsAndSectionCounts => prune(diffs),
	  :currentFilenameId => most_changed_file_id(diffs, current_filename),
	  :wasTag => was_tag,
	  :nowTag => now_tag
	}
  end

private

  include GitDiff
  include ReviewFilePicker

  def was_tag
    tag(:was_tag)
  end

  def now_tag
    tag(:now_tag)
  end

  def tag(name)
    raw = params[name].to_i
    raw != -1 ? raw : @lights.length
  end

  def current_filename
    params[:current_filename]
  end

  def active_avatar_names
    avatars.active.map {|avatar| avatar.name}.sort
  end

  def prev_avatar
    names = active_avatar_names
    return '' if names.length == 1
    names.unshift(names.last)
    return names[names.rindex(avatar_name) - 1]
  end

  def next_avatar
    names = active_avatar_names
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
