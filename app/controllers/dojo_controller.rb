
class DojoController < ApplicationController

  def index
    @name = params[:name].to_s
    # offers new, enter, re_enter, view
  end
 
  def new
    name = params[:name].to_s
    if name == ""
      flash[:new_notice] = 'Please choose a name'
      redirect_to :action => :index    	    	
    elsif Dojo.create(name)
      redirect_to :action => :index, :name => name
    else      
      flash[:new_notice] = 'There is already a CyberDojo named ' + name
      redirect_to :action => :index    	
    end
  end
  
  def enter
    name = params[:name].to_s
    if name == ""
      flash[:enter_notice] = 'Please choose a name'
      redirect_to :action => :index
    elsif !Dojo.find(name)
      flash[:enter_notice] = 'There is no CyberDojo named ' + name
      redirect_to :action => :index, :name => name
    elsif !params[:view] and Dojo.new(params[:name]).expired
      flash[:enter_notice] = 'The CyberDojo named ' + name + ' has ended'
      redirect_to :action => :index, :name => name
    elsif params[:enter]
      redirect_to :controller => :kata, :action => :enter, :dojo => name
    elsif params[:reenter]
      redirect_to :controller => :kata, :action => :reenter, :dojo => name
    elsif params[:view]
      redirect_to :action => :dashboard, :name => name
    end
  end

  def dashboard
    name = params[:name].to_s
    @dojo = Dojo.new(params[:name])
    render :layout => 'dashboard_view'
  end

end
