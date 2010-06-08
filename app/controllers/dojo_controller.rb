
class DojoController < ApplicationController

  protect_from_forgery :only => []

  def index
    redirect_to :action => "choose_dojo"
  end

  def choose_dojo
    @dojo_names = Dojo.names
	if @dojo_names.size == 1
	  redirect_to :action => "choose_avatar", :dojo_name => @dojo_names[0]
	end
  end

  def choose_avatar
    @dojo = Dojo.new(params[:dojo_name])
    @avatars = Avatar.names
  end

  def choose_kata
    @dojo = Dojo.new(params[:dojo_name])
    @avatar_name = params[:avatar_name]
  end

  # Note that I choose in the following order
  #   dojo -> avatar -> kata
  # to minimize the keystrokes needed to finish a kata
  # and start another one (select).

end
