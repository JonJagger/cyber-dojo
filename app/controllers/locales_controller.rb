class LocalesController < ApplicationController

  def change
    session[:locale] = params[:id]
    redirect_to :back
  end

end