
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
    # offers configure, start, resume, dashboard, messages
    @title = '@CyberDojo'
    configure(params)
    @kata_name = kata_name
  end
   
  def create
    configure(params)
    
    filesets_root = params[:filesets_root]
    @languages = folders_in(filesets_root + '/language').sort
    @language_index = rand(@languages.length)
    
    @exercises = folders_in(filesets_root + '/exercise').sort
    @exercise_index = rand(@exercises.length)
    @instructions = { }
    @exercises.each do |name|
      path = filesets_root + '/' + 'exercise' + '/' + name + '/' + 'instructions'
      @instructions[name] = IO.read(path)
    end
    @title = 'configure'
  end
  
  def save
    configure(params)
    
    katas_dir = params[:kata_root]
    io_lock(RAILS_ROOT) do      
      if !File.directory? katas_dir
        Dir.mkdir katas_dir
      end
    end
    
    fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
    info = Kata.create_new(fileset, params)
    
    io_lock(katas_dir) do    
      index_filename = katas_dir + '/' + Kata::Index_filename
      index = File.exists?(index_filename) ? eval(IO.read(index_filename)) : [ ]
      file_write(index_filename, index << info)
    end
    
    redirect_to :action => :index, 
                :kata_name => info[:uuid]
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
        redirect_to "/dojo/full?kata_name=#{kata.id}"
      else
        redirect_to "/kata/edit?kata_name=#{kata.id}&avatar=#{avatar}"
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
    io_lock(kata.dir) do
      available_avatar_names = Avatar.names - kata.avatar_names
      if available_avatar_names == [ ]
        avatar_name = nil
      else          
        avatar_name = random(available_avatar_names)
        Avatar.new(kata, avatar_name)
        kata.post_message(avatar_name, "#{avatar_name} has joined the practice-kata")
        avatar_name
      end        
    end      
  end
  
  def random(array)
    array.shuffle[0]
  end
  
end
