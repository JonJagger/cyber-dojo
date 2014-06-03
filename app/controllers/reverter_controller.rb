
class ReverterController < ApplicationController

  def revert
	tag = params[:tag]
	avatar = dojo.katas[id].avatars[params[:avatar]]
	render :json => {
      :visibleFiles => avatar.visible_files(tag),
	  :inc => avatar.traffic_lights(tag).last
	  #:inc => avatar.lights[tag.to_i]
	}
  end

end
