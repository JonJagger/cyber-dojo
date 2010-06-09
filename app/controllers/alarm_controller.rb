
class AlarmController < ApplicationController

  protect_from_forgery :only => []

  def index
    @duration = params[:every] || 240
    render :layout => 'alarm'
  end

end
