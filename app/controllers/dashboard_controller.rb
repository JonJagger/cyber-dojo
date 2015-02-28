
class DashboardController < ApplicationController

  def show
    gather
    @title = 'dashboard:' + @kata.id[0..5]
  end

  def heartbeat
    gather
    respond_to { |format| format.js }    
  end

  def progress
    render json: { animals: animals_progress }
  end

private

  include DashboardWorker
  
end
