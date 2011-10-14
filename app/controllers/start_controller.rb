
class StartController < ApplicationController
    
  #---------------------
  # Players pick their own avatar animal.
  # This helps interaction, and it also helps players to
  # know what the animal stands for.

  def choose_avatar
    board_config(params)
    @live_avatar_names = @dojo.avatars.map {|avatar| avatar.name }.sort
    @all_avatar_names = Avatar.names
    @notice = choose_your_avatar_message
  end

  def choose_avatar_heartbeat
    board_config(params)
    @live_avatar_names = @dojo.avatars.map {|avatar| avatar.name }.sort
    @all_avatar_names = Avatar.names    
    @notice = choose_your_avatar_message
    respond_to do |format|
      format.js if request.xhr?
    end    
  end
  
  def start_avatar
    board_config(params)
    @started = @dojo.create_new_avatar_folder(params[:avatar])
    respond_to do |format|
      format.js { render(:partial => 'start_avatar') }
    end
  end

private

  def choose_your_avatar_message
    if params[:notice]
      flashed(params[:notice])
    elsif @live_avatar_names == @all_avatar_names
      flashed('Sorry, the dojo is full')
    else
      'Click an avatar to start'
    end
  end
  
  def flashed(message)
    '<span style="font-weight:bold;color:red;">' + message + "</span>"
  end

end
