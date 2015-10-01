
class DifferController < ApplicationController

  def diff
    @lights = avatar.lights.map { |light| light.to_json }
    diffs = git_diff_view(avatar.diff(was_tag, now_tag))
    render json: {
	      lights: @lights,
	      diffs: diffs,
	      prevAvatar: prev_ring(active_avatar_names, avatar_name),
	      nextAvatar: next_ring(active_avatar_names, avatar_name),
	      idsAndSectionCounts: prune(diffs),
	      currentFilenameId: pick_file_id(diffs, current_filename),
	      wasTag: was_tag,
	      nowTag: now_tag
	    }
  end

  private

  include DifferWorker

end
