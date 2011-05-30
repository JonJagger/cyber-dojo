
class DojoController < ApplicationController
 
  def index
    # offers new, start, resume, dashboard
    configure(params)
    @dojo_name = dojo_name
  end
 
  def new
    configure(params)
    if dojo_name == ""
      flash[:new_notice] = 'Please choose a name'
      redirect_to :action => :index    	    	
    elsif Dojo.create(params)
      redirect_to :action => :create, 
                  :dojo_name => dojo_name
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
    @kata_info = {}
    @katas.each do |name|
      path = @dojo.filesets_root + '/' + 'kata' + '/' + name + '/' + 'instructions'
      @kata_info[name] = IO.read(path)
    end        
  end
  
  def save
    configure(params)
    Dojo.configure(params)
    redirect_to :action => :index, 
                :dojo_name => dojo_name
  end
  
  def enter
    configure(params)
    if dojo_name == ""
      flash[:notice] = 'Please choose a name'
      redirect_to :action => :index
    elsif !Dojo.find(params)
      flash[:notice] = 'There is no CyberDojo named ' + dojo_name
      redirect_to :action => :index, 
                  :dojo_name => dojo_name
                  
    elsif params[:start]
      redirect_to :controller => :kata, 
                  :action => :enter, 
                  :dojo_name => dojo_name
                  
    elsif params[:resume]
      redirect_to :action => :resume, 
                  :dojo_name => dojo_name
                  
    elsif params[:dashboard]
      redirect_to :controller => :dashboard,
                  :action => :show_inflated, 
                  :dojo_name => dojo_name
                  
    elsif params[:messages]
      redirect_to :controller => :messages,
                  :action => :show_some, 
                  :dojo_name => dojo_name
    end
  end

  def resume
    board_config(params)
  end
  
  #---------------------------
    
  def ifaq
  end

  #---------------------------
  
  def render_404
    render :file => RAILS_ROOT + '/' + 'public' +'/' + '404.html'
  end
  
  def render_422
    render :file => RAILS_ROOT + '/' + 'public' +'/' + '422.html'
  end
  
  def render_500
    render :file => RAILS_ROOT + '/' + 'public' +'/' + '500.html'
  end
  
private

  def dojo_name
    params[:dojo_name]
  end
  
  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end

  def board_config(params)
    configure(params)
    @dojo = Dojo.new(params)
    avatars = @dojo.avatars
    @languages = avatars.collect { |avatar| avatar.kata.language }.uniq
    @katas = avatars.collect { |avatar| avatar.kata.name }.uniq    
  end
  
end
