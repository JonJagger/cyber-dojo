
class DifferController < ApplicationController

  def diff
    @lights = avatar.lights.map(&:to_json)
    diffs = git_diff_view(avatar_git_diff(avatar, was_tag, now_tag))
    render json: {
                         id: kata.id,
                     avatar: avatar.name,
                     wasTag: was_tag,
                     nowTag: now_tag,
                     lights: @lights,
	                    diffs: diffs,
                 prevAvatar: prev_ring(active_avatar_names, avatar.name),
                 nextAvatar: next_ring(active_avatar_names, avatar.name),
	      idsAndSectionCounts: prune(diffs),
          currentFilenameId: pick_file_id(diffs, current_filename),
	  }
  end

  private

  include DifferWorker

end
