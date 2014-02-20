
class ReverterController < ApplicationController
    
  def revert
	avatar = dojo[id][params[:avatar]]
	render :json => {
      :visibleFiles => avatar.visible_files(params[:tag]),
	  :inc => avatar.traffic_lights(params[:tag]).last
	}
  end

end


