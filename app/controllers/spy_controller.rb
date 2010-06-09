
class SpyController < ApplicationController

  def index
    redirect_to :action => 'choose_dojo'
  end

  def choose_dojo
    @dojo_names = Dojo.names
	if @dojo_names.size == 1
	  redirect_to :action => 'one_dojo', :dojo_name => @dojo_names[0]
	end
  end

  def one_dojo
    @dojo = Dojo.new(params[:dojo_name])
    render :layout => 'spy_one_dojo'
  end

end



