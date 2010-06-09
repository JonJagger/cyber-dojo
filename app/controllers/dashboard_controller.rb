
class DashboardController < ApplicationController

  def index
    @dojo_names = Dojo.names
	if @dojo_names.size == 1
	  redirect_to :action => 'view', :dojo_name => @dojo_names[0]
	end
  end

  def view
    @dojo = Dojo.new(params[:dojo_name])
    render :layout => 'dashboard_view'
  end

end



