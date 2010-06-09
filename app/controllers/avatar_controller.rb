
class AvatarController < ApplicationController

  protect_from_forgery :only => []

  def index
    @dojo = Dojo.new(params[:dojo_name])
    @avatars = Avatar.names
  end

end
