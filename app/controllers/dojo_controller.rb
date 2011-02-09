
class DojoController < ApplicationController

  def index
    @name = name
    # offers new, enter, re_enter, view
  end
 
  def new
    if name == ""
      flash[:new_notice] = 'Please choose a name'
      redirect_to :action => :index    	    	
    elsif Dojo.create(params)
      redirect_to :action => :index, :name => name
    else      
      flash[:new_notice] = 'There is already a CyberDojo named ' + name
      redirect_to :action => :index    	
    end
  end
  
  def enter
    if name == ""
      flash[:enter_notice] = 'Please choose a name'
      redirect_to :action => :index
    elsif !Dojo.find(params)
      flash[:enter_notice] = 'There is no CyberDojo named ' + name
      redirect_to :action => :index, :name => name
    elsif !params[:view] and Dojo.new(params).expired
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
    @dojo = Dojo.new(params)
    render :layout => 'dashboard_view'
  end
  
  def ifaq
  end

private

  def name
    params[:name]
  end
  
end
