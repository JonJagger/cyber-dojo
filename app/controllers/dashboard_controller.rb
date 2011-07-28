
class DashboardController < ApplicationController
   
  def show_inflated
    board_config(params)
    @secs_per_col = 30
    @max_cols = 60
  end

  def heartbeat
    board_config(params)
    @secs_per_col = params[:secs_per_col].to_i
    @max_cols = params[:max_cols].to_i
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def show_deflated
    board_config(params)
  end  
  
end
