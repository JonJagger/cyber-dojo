
require 'Locking'

class DojoController < ApplicationController
    
  include Locking
  extend Locking  
    
  def exists_json
    configure(params)
    @exists = Dojo.exists?(params)
    respond_to do |format|
      format.json { render :json => { :exists => @exists, :message => 'Hello' } }
    end    
  end
    
  def resume_avatar_grid
    board_config(params)
    @live_avatar_names = @dojo.avatar_names
    @all_avatar_names = Avatar.names    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  def index
    # offers configure, start, resume, dashboard, messages
    @title = '@CyberDojo'
    configure(params)
    @dojo_name = dojo_name
    @tab_title = 'Home Page'
  end
   
  def create
    configure(params)
    Dojo.create(params)
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
    
  #------------------------------------------------
  def start
    configure(params)
    if !Dojo.exists?(params)
      redirect_to "/dojo/cant_find?dojo_name=#{dojo_name}"
    else
      dojo = Dojo.new(params)      
      avatar = choose_avatar(dojo)
      if avatar == nil
        redirect_to "/dojo/full?dojo_name=#{dojo.name}"
      else
        redirect_to "/kata/edit?dojo_name=#{dojo.name}&avatar=#{avatar}"
      end
    end    
  end

  def cant_find
    configure(params)
    @dojo_name = dojo_name
  end
  
  def full
    configure(params)
    @dojo_name = dojo_name
  end
    
  #------------------------------------------------
    
  def ifaq
  end

  def conceived
  end
  
  def render_error
    render :file => RAILS_ROOT + '/public/' + params[:n] + '.html'    
  end

  def choose_avatar(dojo)
    io_lock(dojo.folder) do
      available_avatar_names = Avatar.names - dojo.avatar_names
      if available_avatar_names == [ ]
        avatar = nil
      else          
        avatar = available_avatar_names.shuffle[0]
        dojo.create_new_avatar_folder(avatar)
        avatar
      end        
    end      
  end
  
end
