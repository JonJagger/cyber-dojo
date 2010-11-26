
class DojoController < ApplicationController

  def index
  	@name = params[:name].to_s
    # offers new and enter
  end
 
  def new
    name = params[:name].to_s
    if name == ""
      flash[:new_notice] = 'Please choose a name'
      redirect_to :action => 'index'    	    	
    elsif Dojo.create(name)
      redirect_to :action => 'index', :name => name
    else      
      flash[:new_notice] = 'Sorry, there is already a CyberDojo named ' + name
      redirect_to :action => 'index'    	
    end
  end
  
  def enter
    name = params[:name].to_s
    if name == ""
      flash[:enter_notice] = 'Please choose a name'
      redirect_to :action => 'index'    	    	    	
    elsif Dojo.find(name)
      redirect_to :controller => 'kata', :action => 'index', :dojo => name
    else      
      flash[:enter_notice] = 'There is no dojo named: ' + name
      redirect_to :action => 'index'
    end
  end

  def dashboard
    name = params[:name].to_s
    @dojo = Dojo.new(params[:name])
    render :layout => 'dashboard_view'
  end

end
