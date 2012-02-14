
require 'Locking'

class DojoController < ApplicationController
    
  include Locking
  extend Locking  
    
  def exists_json
    configure(params)
    @exists = Kata.exists?(params)
    respond_to do |format|
      format.json { render :json => { :exists => @exists, :message => 'Hello' } }
    end    
  end
    
  def resume_avatar_grid
    board_config(params)
    @live_avatar_names = @kata.avatar_names
    @all_avatar_names = Avatar.names    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  def index
    # offers configure, start, resume, dashboard, messages
    @title = '@CyberDojo'
    configure(params)
    @kata_name = kata_name
    @tab_title = 'Home Page'
  end
   
  def create
    configure(params)
    Kata.create(params)
    @kata = Kata.new(params)
    
    @languages = FileSet.new(@kata.filesets_root, 'language').choices
    @language_index = rand(@languages.length)
    @exercise_info = { }
    @exercises = FileSet.new(@kata.filesets_root, 'exercise').choices
    @exercise_index = rand(@exercises.length)
    @exercises.each do |name|
      path = @kata.filesets_root + '/' + 'exercise' + '/' + name + '/' + 'instructions'
      @exercise_info[name] = IO.read(path)
    end
    @tab_title = 'Configure'
  end
  
  def save
    configure(params)
    Kata.configure(params)
    redirect_to :action => :index, 
                :kata_name => kata_name
  end  
    
  #------------------------------------------------
  
  def start
    configure(params)
    if !Kata.exists?(params)
      redirect_to "/dojo/cant_find?kata_name=#{kata_name}"
    else
      kata = Kata.new(params)      
      avatar = start_avatar(kata)
      if avatar == nil
        redirect_to "/dojo/full?kata_name=#{kata.name}"
      else
        redirect_to "/kata/edit?kata_name=#{kata.name}&avatar=#{avatar}"
      end
    end    
  end

  def cant_find
    configure(params)
    @kata_name = kata_name
  end
  
  def full
    configure(params)
    @kata_name = kata_name
  end
    
  #------------------------------------------------
    
  def ifaq
  end

  def conceived
  end
  
  def render_error
    render :file => RAILS_ROOT + '/public/' + params[:n] + '.html'    
  end

  def start_avatar(kata)
    io_lock(kata.folder) do
      available_avatar_names = Avatar.names - kata.avatar_names
      if available_avatar_names == [ ]
        avatar_name = nil
      else          
        avatar_name = available_avatar_names.shuffle[0]
        Avatar.new(kata, avatar_name)
        kata.post_message(avatar_name, "#{avatar_name} has joined the practice-kata")
        avatar_name
      end        
    end      
  end
  
end
