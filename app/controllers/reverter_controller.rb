
class ReverterController < ApplicationController

  def revert
	tag = params[:tag]
	avatar = dojo.katas[id].avatars[params[:avatar]]
	render :json => {
      :visibleFiles => avatar.tags[tag].visible_files,
	  :light => avatar.traffic_lights(tag).last
	  #:light => avatar.lights[tag.to_i]
	}
  end

end
