
class DashboardController < ApplicationController
   
  # TODO: replace updown control this with simple control to enter the
  #       value you'd like together with a refresh/redraw button.
  # secs/col [input]
  #    REDRAW
  # max cols [input]

  # I'd like the dashboard for a finished dojo to be pure client side.
  # Create all diffs for all increments for all animals, together with
  # a client-side dashboard in a single html file.
  # This will allow a replay of a session to happen without any interaction
  # with the server. A finished dojo will be one that has timed out
  # after 60 minutes. I plan to introduce the fixed timeout only when
  # you can start a new dojo from any traffic-light.

  def show_inflated
    board_config(params)
    @secs_per_col = 30
    @max_cols = 60
    @tab_title = 'Dashboard'
  end

  def inflated_heartbeat
    board_config(params)
    @secs_per_col = params[:secs_per_col].to_i
    @max_cols = params[:max_cols].to_i
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def show_deflated
    board_config(params)
    @tab_title = 'Dashboard'
  end  
  
end
