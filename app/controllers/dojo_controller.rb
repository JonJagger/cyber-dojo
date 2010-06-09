
class DojoController < ApplicationController

  protect_from_forgery :only => []

  # Note that I choose in the following order
  #   dojo -> avatar -> kata
  # to minimize the keystrokes needed to finish a kata
  # and start another one (select).

  def index
    @dojo_names = Dojo.names
	if @dojo_names.size == 1
	  redirect_to :controller => 'avatar',
                  :dojo_name => @dojo_names[0]
	end
  end

  def sound_driver_rotate_alarm
    @duration = params[:duration] || 240
    render :layout => 'sound_driver_rotate_alarm'
  end

end
