
require 'Files'
require 'Folders'
require 'Locking'
require 'make_time_helper'

class DojoController < ApplicationController
    
  include MakeTimeHelper
  
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
  
  def index
    # offers create, start, resume, dashboard
    @title = 'Home'
    @id = id
  end
   
  def create
    @languages = Folders::in(root_dir + '/languages').sort    
    @exercises = Folders::in(root_dir + '/exercises').sort
    @instructions = { }
    @exercises.each do |exercise|
      # TODO: refactor to use Exercise class
      path = root_dir + '/exercises/' + exercise + '/' + 'instructions'
      @instructions[exercise] = IO.read(path)
    end
    @title = 'new-practice'
  end
  
  def save
    katas_root_dir = root_dir + '/katas'
    Locking::io_lock(root_dir) do      
      if !File.directory? katas_root_dir
        Dir.mkdir katas_root_dir
      end
    end
    
    language = Language.new(root_dir, params['language'])    
    exercise = Exercise.new(root_dir, params['exercise'])
    
    index_info = { 
      :name => params['name'],
      :created => make_time(Time.now),
      :id => `uuidgen`.strip.delete('-')[0..9],      
      :browser => browser,
      :language => language.name,
      :exercise => exercise.name,
    }
    
    kata_info = index_info.clone
    kata_info[:visible_files] = language.visible_files
    kata_info[:visible_files]['output'] = ''
    kata_info[:visible_files]['instructions'] = exercise.instructions
    kata_info[:unit_test_framework] = language.unit_test_framework
    kata_info[:tab_size] = language.tab_size
    
    Kata.create_new(root_dir, kata_info)
    
    Locking::io_lock(katas_root_dir) do    
      index_filename = katas_root_dir + '/' + Kata::Index_filename
      index = File.exists?(index_filename) ? eval(IO.read(index_filename)) : [ ]
      Files::file_write(index_filename, index << index_info)
    end
    
    redirect_to :action => :index, 
                :id => index_info[:id]
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
  
  def render_error
    render :file => RAILS_ROOT + '/public/' + params[:n] + '.html'    
  end

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
  
  def random(array)
    array.shuffle[0]
  end
  
end
