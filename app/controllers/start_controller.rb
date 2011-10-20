
class StartController < ApplicationController
    
  #---------------------
  # Players pick their own avatar animal.
  # This helps interaction, and it also helps players to
  # know what the animal stands for.

  # TODO: Dojo is full message on Start Coding page
  # TODO: Dojo is empty message on Resume Coding page?
  # TODO: create avatar_name method same way as dojo_name in application_controller
  # TODO: better tooltips for b&w and colour images for start and resume pages
  
  def choose_avatar
    board_config(params)
    @live_avatar_names = @dojo.avatar_names
    @all_avatar_names = Avatar.names
    @tab_title = 'Start Coding'
  end

  def choose_avatar_heartbeat
    board_config(params)
    @live_avatar_names = @dojo.avatar_names
    @all_avatar_names = Avatar.names    
    respond_to do |format|
      format.js if request.xhr?
    end    
  end
  
  def chosen_avatar
    board_config(params)
    avatar_name = params[:avatar]
    started = @dojo.create_new_avatar_folder(avatar_name)
    if started
      redirect_to :controller => :kata,
                  :action => :edit, 
                  :dojo_name => dojo_name,
                  :avatar => avatar_name
    else
      #TODO else if dojo.finished redirect_to :action => :closed
      #     or will that simply give you a screen full of b&w images
      redirect_to :action => :pipped,
                  :dojo_name => dojo_name,
                  :avatar => avatar_name
    end
  end

  def pipped
    board_config(params)
    @avatar_name = params[:avatar]
  end

end
