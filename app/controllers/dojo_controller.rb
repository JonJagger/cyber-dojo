
require 'Locking'

class DojoController < ApplicationController
  
  def index
    @title = 'Home'
    @id = id
    @buttons = ['about','basics','donations','faqs','feedback','links','source','tips','why' ]
  end
 
  #------------------------------------------------
  
  def exists_json
    respond_to do |format|
      format.json {
        render :json => { :exists => Kata.exists?(root_dir, id) }
      }
    end    
  end
  
  #------------------------------------------------

  def start_json
    exists = Kata.exists?(root_dir, id)
    avatar_name = exists ? start_avatar(Kata.new(root_dir, id)) : nil
    full = (avatar_name == nil)
    respond_to do |format|
      format.json { render :json => {
          :exists => exists,
          :avatar_name => avatar_name,
          :full => full
        }
      }
    end
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

  def random(array)
    array.shuffle[0]
  end
  
end
