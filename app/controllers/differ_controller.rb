
class DifferController < ApplicationController

  def diff
    @lights = avatar.lights.map{|light| light.to_json }
    diffs = git_diff_view(avatar.tags[was_tag].diff(now_tag))
	render :json => {
	  :lights => @lights,
	  :diffs => diffs,
	  :prevAvatar => prev_ring(active_avatar_names,avatar_name),
	  :nextAvatar => prev_ring(active_avatar_names,avatar_name),
	  :idsAndSectionCounts => prune(diffs),
	  :currentFilenameId => pick_file_id(diffs, current_filename),
	  :wasTag => was_tag,
	  :nowTag => now_tag
	}
  end

private

  include GitDiff
  include ReviewFilePicker
  include PrevNextRing

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
    @active_avatar_names ||= avatars.active.map {|avatar| avatar.name}.sort
  end

  def prune(array)
    # diff-view has been refactored so each diff-view has its own
    # pair of [line-number,content] divs. The filenames are handled
    # separately and only need :id and :section_count entries.
    array.map {|hash| { :id => hash[:id], :section_count => hash[:section_count] } }
  end

end
