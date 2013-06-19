require 'Locking'

class DojoController < ApplicationController
  
  def index
    @title = 'Home'
    @id = id
  end
 
  def button_dialog
    name = params[:id]
    render :partial => "/dojo/dialog_#{name}.html.erb",
           :layout => false
  end
 
  #------------------------------------------------
  
  def start_json
    exists = Kata.exists?(root_dir, id)
    avatar_name = exists ? start_avatar(Kata.new(root_dir, id)) : nil
    full = (avatar_name == nil)
    render :json => {
      :exists => exists,
      :avatar_name => avatar_name,
      :full => full,
      :start_dialog_html => (full ? '' : start_dialog_html(avatar_name))
    }
  end
  
  def start_dialog_html(avatar_name)
    @avatar_name = avatar_name
    bind('/app/views/dojo/start_dialog.html.erb')
  end
  
  #------------------------------------------------
  
  def resume_json
    exists = Kata.exists?(root_dir, id)
    kata = exists ? Kata.new(root_dir, id) : nil;
    started_avatar_names = exists ? kata.avatars.collect{|avatar| avatar.name} : [ ]
    empty = (started_avatar_names == [ ])
    render :json => {
      :exists => exists,
      :empty => empty,
      :resume_dialog_html => (exists ? resume_dialog_html(kata, started_avatar_names) : '')
    }
  end

  def resume_dialog_html(kata, started_avatar_names)
    @kata = kata
    @started_avatar_names = started_avatar_names
    @all_avatar_names = Avatar.names
    bind('/app/views/dojo/resume_dialog.html.erb')    
  end
  
  #------------------------------------------------
  
  def review_json
    exists = Kata.exists?(root_dir, id)    
    render :json => {
      :exists => exists,
      :review_dialog_html => (exists ? review_dialog_html : '')          
    }
  end
  
  def review_dialog_html
    bind('/app/views/dojo/review_dialog.html.erb')
  end

  #------------------------------------------------
  
  def render_error
    render "error/#{params[:n]}"
  end

  #------------------------------------------------
  
  def start_avatar(kata)
    Locking::io_lock(kata.dir) do
      started_avatar_names = kata.avatars.collect { |avatar| avatar.name }
      unstarted_avatar_names = Avatar.names - started_avatar_names
      if unstarted_avatar_names == [ ]
        avatar_name = nil
      else          
        avatar_name = random(unstarted_avatar_names)
        Avatar.new(kata, avatar_name)
        avatar_name
      end        
    end      
  end
  
private  

  def random(array)
    array.shuffle[0]
  end
  
end
