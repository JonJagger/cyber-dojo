
class ReverterController < ApplicationController
    
  def revert
	kata = Kata.new(root_dir, id)
	avatar = Avatar.new(kata, params[:avatar])
	visible_files = avatar.visible_files(params[:tag])
	traffic_lights = avatar.traffic_lights(params[:tag])
	render :json => {
      :visibleFiles => visible_files,
	  :inc => traffic_lights.last          
	}
  end

end


