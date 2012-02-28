
require 'Files'
require 'Folders'
require 'Locking'

class DojoController < ApplicationController
    
  include Files
  extend Files 
  include Folders
  extend Folders  
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
    # offers create, start, resume, dashboard
    @title = 'Home'
    @id = id
  end
   
  def create
    configure(params)
    
    filesets_root_dir = params[:filesets_root_dir]
    @languages = folders_in(filesets_root_dir + '/language').sort
    
    @exercises = folders_in(filesets_root_dir + '/exercise').sort
    @instructions = { }
    @exercises.each do |exercise|
      path = filesets_root_dir + '/' + 'exercise' + '/' + exercise + '/' + 'instructions'
      @instructions[exercise] = IO.read(path)
    end
    @title = 'new-practice'
  end
  
  def save
    configure(params)
    
    katas_root_dir = params[:katas_root_dir]
    io_lock(RAILS_ROOT) do      
      if !File.directory? katas_root_dir
        Dir.mkdir katas_root_dir
      end
    end
    
    info = Kata.create_new(InitialFileSet.new(params))
    
    io_lock(katas_root_dir) do    
      index_filename = katas_root_dir + '/' + Kata::Index_filename
      index = File.exists?(index_filename) ? eval(IO.read(index_filename)) : [ ]
      file_write(index_filename, index << info)
    end
    
    # This is not working in IE7, perhaps add :controller => 'dojo'
    redirect_to :action => :index, 
                :id => info[:id]
  end  
    
  #------------------------------------------------
  
  def start
    configure(params)
    if !Kata.exists?(params)
      redirect_to "/dojo/cant_find?id=#{id}"
    else
      kata = Kata.new(params)      
      avatar = start_avatar(kata)
      if avatar == nil
        redirect_to "/dojo/full?id=#{id}"
      else
        redirect_to "/kata/edit?id=#{id}&avatar=#{avatar}"
      end
    end    
  end

  def cant_find
    configure(params)
    @id = id
  end
  
  def full
    board_config(params)
    @id = id
  end
    
  #------------------------------------------------
    
  def faqs
    respond_to do |format|    
      format.html { render :layout => false }
    end
  end

  def links
    respond_to do |format|    
      format.html { render :layout => false }
    end
  end
  
  def tips
    respond_to do |format|    
      format.html { render :layout => false }
    end
  end
  
  def why
    respond_to do |format|    
      format.html { render :layout => false }
    end
  end
  
  def render_error
    render :file => RAILS_ROOT + '/public/' + params[:n] + '.html'    
  end

  def start_avatar(kata)
    io_lock(kata.dir) do
      available_avatar_names = Avatar.names - kata.avatar_names
      if available_avatar_names == [ ]
        avatar_name = nil
      else          
        avatar_name = random(available_avatar_names)
        Avatar.new(kata, avatar_name)
        avatar_name
      end        
    end      
  end
  
  def random(array)
    array.shuffle[0]
  end
  
end
