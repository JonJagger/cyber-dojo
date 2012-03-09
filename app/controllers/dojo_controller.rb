
require 'Files'
require 'Folders'
require 'Locking'
require 'Uuid'
require 'make_time_helper'

class DojoController < ApplicationController
    
  include MakeTimeHelper
  
  #------------------------------------------------
  
  def index
    @title = 'Home'
    @id = id
  end
   
  #------------------------------------------------

  def create
    @languages = Folders::in(root_dir + '/languages').sort    
    @exercises = Folders::in(root_dir + '/exercises').sort
    @instructions = { }
    @exercises.each do |exercise|
      @instructions[exercise] = Exercise.new(root_dir, exercise).instructions
    end
    @title = 'new-practice'
  end
    
  #------------------------------------------------

  def save
    info = save_to_index
    language = Language.new(root_dir, info[:language])
    exercise = Exercise.new(root_dir, info[:exercise])
    info[:visible_files] = language.visible_files
    info[:visible_files]['output'] = ''
    info[:visible_files]['instructions'] = exercise.instructions
    
    Kata.create_new(root_dir, info)
    
    redirect_to :action => :index, 
                :id => info[:id]
  end  
    
  #------------------------------------------------
    
  def diff_save
    info = save_to_index
    info[:diff_id] = params['id']
    info[:diff_language] = params['language']
    info[:diff_exercise] = params['exercise']
    info[:diff_avatar] = params['avatar']
    info[:diff_tag] = params['tag']      
        
    kata = Kata.new(root_dir, info[:diff_id])
    avatar = Avatar.new(kata, info[:diff_avatar])
    info[:visible_files] = avatar.visible_files(info[:diff_tag])
    
    Kata.create_new(root_dir, info)
    
    redirect_to :action => :start, 
                :id => info[:id]
  end
  
  #------------------------------------------------
  
  def start
    if !Kata.exists?(root_dir, id)
      redirect_to "/dojo/cant_find?id=#{id}"
    else
      kata = Kata.new(root_dir, id)      
      avatar = start_avatar(kata)
      if avatar == nil
        redirect_to "/dojo/full?id=#{id}"
      else
        redirect_to "/kata/edit?id=#{id}&avatar=#{avatar}"
      end
    end    
  end

  #------------------------------------------------
  
  def cant_find
    @id = id
  end
  
  def full
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
  
  #------------------------------------------------

  def exists_json
    @exists = Kata.exists?(root_dir, id)
    respond_to do |format|
      format.json { render :json => { :exists => @exists, :message => 'Hello' } }
    end    
  end
    
  def resume_avatar_grid
    @kata = Kata.new(root_dir, id)    
    @live_avatar_names = @kata.avatar_names
    @all_avatar_names = Avatar.names    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  #------------------------------------------------
      
  def render_error
    render :file => RAILS_ROOT + '/public/' + params[:n] + '.html'    
  end

  #------------------------------------------------
  
  def start_avatar(kata)
    Locking::io_lock(kata.dir) do
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
  
  #------------------------------------------------
  
  def save_to_index
    katas_root_dir = root_dir + '/katas'
    Locking::io_lock(root_dir) do      
      if !File.directory? katas_root_dir
        Dir.mkdir katas_root_dir
      end
    end
    
    language = Language.new(root_dir, params['language'])    
    
    info = {
      :created => make_time(Time.now),
      :id => Uuid.gen,
      :browser => browser,
      :language => language.name,
      :exercise => params['exercise']
    }
    
    info[:name]= params['name'] if params['name']
    
    Locking::io_lock(katas_root_dir) do    
      index_filename = katas_root_dir + '/' + Kata::Index_filename
      index = File.exists?(index_filename) ? eval(IO.read(index_filename)) : [ ]
      Files::file_write(index_filename, index << info)
    end
    
    info[:unit_test_framework] = language.unit_test_framework
    info[:tab_size] = language.tab_size
    info
  end
  
  #------------------------------------------------
  
  def random(array)
    array.shuffle[0]
  end
  
end
