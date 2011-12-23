
require 'Locking'

class DojoController < ApplicationController
    
  include Locking
  extend Locking  
    
  def index
    # offers new, start, resume, dashboard, messages
    @title = 'Deliberate Software' + '<br/>' + 'Team Practice'
    configure(params)
    @dojo_name = dojo_name
    @tab_title = 'Home Page'
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
    @kata_index = rand(@katas.length)
    @languages = FileSet.new(@dojo.filesets_root, 'language').choices
    @language_index = rand(@languages.length)
    @kata_info = {}
    @katas.each do |name|
      path = @dojo.filesets_root + '/' + 'kata' + '/' + name + '/' + 'instructions'
      @kata_info[name] = IO.read(path)
    end
    @tab_title = 'Configure'
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
      dojo = Dojo.new(params)
      io_lock(dojo.folder) do
        available_avatar_names = Avatar.names - dojo.avatar_names
        if available_avatar_names != [ ]
          avatar_name = available_avatar_names.shuffle[0]
          dojo.create_new_avatar_folder(avatar_name)
          redirect_to :controller => :kata,
              :action => :edit, 
              :dojo_name => dojo_name,
              :avatar => avatar_name
        else
          redirect_to :controller => :dojo,
              :action => :full,
              :dojo_name => dojo_name
        end
      end                  
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
  
  def full
    configure(params)
    @dojo = Dojo.new(params)
    @all_avatar_names = Avatar.names
  end
  
  def ifaq
  end

  def conceived
  end
  
  def render_error
    render :file => RAILS_ROOT + '/public/' + params[:n] + '.html'    
  end

end
