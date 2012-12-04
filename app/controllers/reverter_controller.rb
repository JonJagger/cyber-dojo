
class ReverterController < ApplicationController
    
  def revert
	kata = Kata.new(root_dir, id)
	avatar = Avatar.new(kata, params[:avatar])
	visible_files = avatar.visible_files(params[:tag])
	increments = avatar.increments(params[:tag])
	respond_to do |format|
	  format.json { render :json => {
	      :visibleFiles => visible_files,
	      :inc => increments.last          
	    }
	  }
	end
  end

end


