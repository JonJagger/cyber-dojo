
class DojoController < ApplicationController
 
  def index
    @dojo_name = dojo_name
    # offers new, enter, re_enter, review
  end
 
  def new
    configure(params)
    if dojo_name == ""
      flash[:new_notice] = 'Please choose a name'
      redirect_to :action => :index    	    	
    elsif Dojo.create(params)
      redirect_to :action => :create, :dojo_name => dojo_name
    else      
      flash[:new_notice] = 'There is already a CyberDojo named ' + dojo_name
      redirect_to :action => :index    	
    end
  end
  
  def create
    configure(params) 
    @dojo = Dojo.new(params)
    @katas = FileSet.new(@dojo.filesets_root, 'kata').choices
    @languages = FileSet.new(@dojo.filesets_root, 'language').choices
    @durations = Dojo::duration_choices
    @rotations = Dojo::rotation_choices
    @kata_info = {}
    @katas.each do |name|
      path = @dojo.filesets_root + '/' + 'kata' + '/' + name + '/' + 'instructions'
      @kata_info[name] = IO.read(path)
    end        
  end
  
  def save
    configure(params)
    Dojo.configure(params)
    redirect_to :action => :index, :dojo_name => dojo_name
  end
  
  def enter
    configure(params)
    if dojo_name == ""
      flash[:enter_notice] = 'Please choose a name'
      redirect_to :action => :index
    elsif !Dojo.find(params)
      flash[:enter_notice] = 'There is no CyberDojo named ' + dojo_name
      redirect_to :action => :index, :dojo_name => dojo_name
    elsif !params[:review] and Dojo.new(params).closed
      flash[:enter_notice] = 'The CyberDojo named ' + dojo_name + ' has ended'
      redirect_to :action => :index, :dojo_name => dojo_name
    elsif params[:enter]
      redirect_to :controller => :kata, :action => :enter, :dojo_name => dojo_name
    elsif params[:reenter]
      redirect_to :action => :reenter, :dojo_name => dojo_name
    elsif params[:review]
      redirect_to :action => :dashboard, :dojo_name => dojo_name
    end
  end

  def reenter
    configure(params)
    @dojo = Dojo.new(params) 
    render :layout => 'dashboard_view'
  end
  
  def dashboard
    configure(params)
    @dojo = Dojo.new(params)
    render :layout => 'dashboard_view'
  end
  
  def ifaq
  end

private

  def dojo_name
    params[:dojo_name]
  end
  
  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end

end
