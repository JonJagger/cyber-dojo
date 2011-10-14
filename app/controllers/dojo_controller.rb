
class DojoController < ApplicationController
    
  def index
    # offers new, start, resume, dashboard, messages
    @title = 'Deliberate Software' + '<br/>' + 'Team Practice'
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
      redirect_to :controller => :start,
                  :action => :choose_avatar, 
                  :dojo_name => dojo_name
                  
    elsif params[:resume]
      redirect_to :controller => :resume,
                  :action => :choose_avatar, 
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

  #---------------------
  # Players pick their own avatar animal on entering a dojo.
  # This helps interaction, and it also helps players to know what
  # the animal stands for.

  def start
    board_config(params)
    @live_avatar_names = @dojo.avatars.map {|avatar| avatar.name }.sort
    @all_avatar_names = Avatar.names
    @notice = start_choose_your_avatar_message
  end

  def start_heartbeat
    board_config(params)
    @live_avatar_names = @dojo.avatars.map {|avatar| avatar.name }.sort
    @all_avatar_names = Avatar.names    
    @notice = start_choose_your_avatar_message
    respond_to do |format|
      format.js if request.xhr?
    end    
  end
  
  def start_avatar
    board_config(params)
    @started = @dojo.create_new_avatar_folder(params[:avatar])
    respond_to do |format|
      format.js { render(:partial => 'start_avatar') }
    end
  end

  def start_choose_your_avatar_message
    if params[:notice]
      flashed(params[:notice])
    elsif @live_avatar_names == @all_avatar_names
      flashed('Sorry, the dojo is full')
    else
      'Click an avatar to start'
    end
  end
  
  #---------------------

  def resume
    board_config(params)
    @live_avatar_names = @dojo.avatars.map {|avatar| avatar.name }
    @all_avatar_names = Avatar.names
    @notice = resume_choose_your_avatar_message
  end
  
  def resume_heartbeat
    board_config(params)
    @live_avatar_names = @dojo.avatars.map {|avatar| avatar.name }
    @all_avatar_names = Avatar.names    
    @notice = resume_choose_your_avatar_message
    respond_to do |format|
      format.js if request.xhr?
    end    
  end

  def resume_choose_your_avatar_message
    if @live_avatar_names == [ ] 
      flashed('No-one has started yet')
    else
      'Click an avatar to resume it'
    end
  end

  def flashed(message)
    '<span style="font-weight:bold;color:red;">' + message + "</span>"
  end
  
  def ifaq
  end

  def conceived
  end
  
  def render_404
    render :file => RAILS_ROOT + '/public/404.html'
  end
  
  def render_422
    render :file => RAILS_ROOT + '/public/422.html'
  end
  
  def render_500
    render :file => RAILS_ROOT + '/public/500.html'
  end

end
