
class ViewController < ApplicationController

  def index
    redirect_to :action => "view"
  end

  def view
  end
  
end



