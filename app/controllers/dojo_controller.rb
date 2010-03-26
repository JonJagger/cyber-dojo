
class DojoController < ApplicationController

  protect_from_forgery :only => []

  def index
    redirect_to :action => "choose_language", :id => params[:id]
  end

  def choose_language
  end

  def choose_avatar
    # retain the kata-id if there is one
    if defined? params[:kata_id]
      @kata_id = params[:kata_id]
    else
      @kata_id = ""
    end
    @avatars = Avatar.names
    @title = "Cyber Dojo"
  end

end
