
class LocalesController < ApplicationController

  def change
    Rails.logger.warn("session[:locale](#{session[:locale]}) << #{params[:id]}")
    session[:locale] = params[:id]
    redirect_to :back
  end

end