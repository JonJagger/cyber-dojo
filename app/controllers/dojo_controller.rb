
class DojoController < ApplicationController

  protect_from_forgery :only => []

  def index
    # retain the kata-id if there is one
    if defined? params[:id]
      @kata_id = params[:id]
    else
      @kata_id = ""
    end
    @avatars = Avatar.names
    @title = "Cyber Dojo"
  end

  def help
  end

end
