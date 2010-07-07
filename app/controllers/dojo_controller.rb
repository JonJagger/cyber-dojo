
class DojoController < ApplicationController

  def index
    # offers new/enter/dashboard choice
  end

  def new
    name = params[:name]
    folder = RAILS_ROOT + '/dojos/' + name
    if !File.exists?(folder)
      Dir.mkdir(folder)
    end
    redirect_to :controller => 'kata', 
                :action => 'index',
                :dojo => name
  rescue
    flash[:new_notice] = 'Illegal dojo name: ' + name
    redirect_to :action => 'index'
  end

  def enter
    name = params[:name]
    if !File.exists?(RAILS_ROOT + '/dojos/' + name)
      flash[:enter_notice] = 'There is no dojo named: ' + name
      redirect_to :action => 'index'
    else
      redirect_to :controller => 'kata', 
                  :action => 'index',
                  :dojo => name
    end
  end

  def dashboard
    name = params[:name]
    if !File.exists?(RAILS_ROOT + '/dojos/' + name)
      flash[:dashboard_notice] = 'There is no dojo named: ' + name
      redirect_to :action => 'index'
    else
      @dojo = Dojo.new(params[:name])
      render :layout => 'dashboard_view'
    end
  end

end
