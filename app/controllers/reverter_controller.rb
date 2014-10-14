
class ReverterController < ApplicationController

  def revert
	tag = params[:tag].to_i
	render :json => {
      :visibleFiles => avatar.tags[tag].visible_files,
	}
  end

end
