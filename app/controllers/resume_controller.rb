
class ResumeController < ApplicationController

  def choose_avatar
    @tab_title = 'Resume Coding'
    board_config(params)
    @live_avatar_names = @dojo.avatar_names
    @all_avatar_names = Avatar.names
    @notice = choose_your_avatar_message
  end
  
  def choose_your_avatar_message
    if @live_avatar_names == [ ] 
      flashed('No-one has started yet')
    else
      'Click an avatar to resume it'
    end
  end

  def flashed(message)
    '<span style="font-weight:bold;color:red;">' + message + "</span>"
  end

end
