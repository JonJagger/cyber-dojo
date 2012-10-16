
require 'erb'

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
    @title = 'Setup'
  end
  
  #------------------------------------------------

  def save
    info = gather_info
    language = Language.new(root_dir, info[:language])
    exercise = Exercise.new(root_dir, info[:exercise])
    vis = info[:visible_files] = language.visible_files
    vis['output'] = ''
    vis['instructions'] = exercise.instructions
    Kata.create_new(root_dir, info)
    
    redirect_to :action => :index, 
                :id => info[:id]
  end  
  
  #------------------------------------------------
  
  def diff_save
    kata = Kata.new(root_dir, params['id'])
    params['language'] = kata.language.name
    params['exercise'] = kata.exercise.name
    info = gather_info
    info[:diff_id] = params['id']
    info[:diff_language] = params['language']
    info[:diff_exercise] = params['exercise']
    info[:diff_avatar] = params['avatar']
    info[:diff_tag] = params['tag']      
        
    kata = Kata.new(root_dir, info[:diff_id])
    avatar = Avatar.new(kata, info[:diff_avatar])
    info[:visible_files] = avatar.visible_files(info[:diff_tag])
    
    Kata.create_new(root_dir, info)
    
    redirect_to :action => :index, 
                :id => info[:id]
  end
  
  #------------------------------------------------

  def exists_json
    respond_to do |format|
      format.json { render :json => { :exists => Kata.exists?(root_dir, id) } }
    end    
  end
  
  #------------------------------------------------

  def start_json
    exists = Kata.exists?(root_dir, id)
    avatar_name = exists ? start_avatar(Kata.new(root_dir, id)) : nil
    full = (avatar_name == nil)
    start_grid = full ? '' : start_avatar_grid(avatar_name)
    respond_to do |format|
      format.json { render :json => {
          :exists => exists,
          :avatar_name => avatar_name,
          :full => full,
          :start_grid => start_grid
        }
      }
    end
  end
  
  #------------------------------------------------

  def start_avatar_grid(avatar_name)
    @avatar_name = avatar_name
    filename = root_dir + '/app/views/dojo/start_avatar_grid.html.erb'
    ERB.new(File.read(filename)).result(binding)
  end
  
  #------------------------------------------------
  
  def resume_avatar_grid
    @kata = Kata.new(root_dir, id)    
    @live_avatar_names = @kata.avatar_names
    @all_avatar_names = Avatar.names    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
  #------------------------------------------------

  def full_avatar_grid
    @id = id
    @all_avatar_names = Avatar.names    
  end
  
  #------------------------------------------------
  
  def render_error
    render "error/#{params[:n]}"
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
  
  def gather_info    
    language = Language.new(root_dir, params['language'])    
    
    { :created => make_time(Time.now),
      :id => Uuid.gen,
      :browser => browser,
      :language => language.name,
      :exercise => params['exercise'],
      :unit_test_framework => language.unit_test_framework,
      :tab_size => language.tab_size
    }
  end
  
  #------------------------------------------------
  
  def random(array)
    array.shuffle[0]
  end
  
end
