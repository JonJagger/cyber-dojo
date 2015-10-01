
class ReverterController < ApplicationController

  def revert
    render json: {
      visibleFiles: avatar.tags[tag].visible_files
    }
  end

  private

  def tag
    params[:tag].to_i
  end

end
