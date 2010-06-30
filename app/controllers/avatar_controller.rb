
class AvatarController < ApplicationController

  def index
    @dojo = Dojo.new(params[:dojo_name])
    @avatars = Avatar.names
    @languages = Language.names
    @katas = Kata.names
  end

end
