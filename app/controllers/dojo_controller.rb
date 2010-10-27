
class DojoController < ApplicationController

  def index
  	@name = params['name'] || "MyCyberDojoName"
    # offers new/enter
  end
 
  def new
    name = params['name'].to_s
    folder = RAILS_ROOT + '/dojos/' + name
    if name == ""
      flash[:new_notice] = 'Please choose a name'
      redirect_to :action => 'index'    	    	
    elsif File.exists?(folder)
      flash[:new_notice] = 'Sorry, there is already a CyberDojo named ' + name
      redirect_to :action => 'index'    	
    else    	
      Dir.mkdir(folder)
      redirect_to :action => 'index', :name => name
    end
  rescue
    flash[:new_notice] = 'Sorry, illegal name: ' + name
    redirect_to :action => 'new'
  end
  
  def enter
    name = params[:name]
    folder = RAILS_ROOT + '/dojos/' + name
    if name == ""
      flash[:enter_notice] = 'Please choose a name'
      redirect_to :action => 'index'    	    	    	
    elsif !File.exists?(folder)
      flash[:enter_notice] = 'There is no dojo named: ' + name
      redirect_to :action => 'index'
    else
      redirect_to :controller => 'kata', :action => 'index', :dojo => name
    end
  end

  def dashboard
    name = params[:name]
    @dojo = Dojo.new(params[:name])
    render :layout => 'dashboard_view'
  end

end
