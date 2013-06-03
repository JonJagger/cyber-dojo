
require 'Locking'

class DojoController < ApplicationController
  
  def index
    @title = 'Home'
    @id = id
  end
 
  def show_dialog
    name = params[:id]
    respond_to do |format|
      format.json {
        render :json => { :html => bind("/app/views/dojo/button_#{name}_dialog.html.erb") }
      }
    end
  end
 
  #------------------------------------------------
  
  def start_json
    exists = Kata.exists?(root_dir, id)
    avatar_name = exists ? start_avatar(Kata.new(root_dir, id)) : nil
    full = (avatar_name == nil)
    respond_to do |format|
      format.json {
        render :json => {
          :exists => exists,
          :avatar_name => avatar_name,
          :full => full,
          :start_dialog_html => (full ? '' : start_dialog_html(avatar_name))
        }
      }
    end
  end
  
  def start_dialog_html(avatar_name)
    @avatar_name = avatar_name
    bind('/app/views/dojo/start_dialog.html.erb')
  end
  
  #------------------------------------------------
  
  def resume_json
    exists = Kata.exists?(root_dir, id)
    kata = exists ? Kata.new(root_dir, id) : nil;
    live_avatar_names = exists ? kata.avatar_names : [ ]
    empty = (live_avatar_names == [ ])
    respond_to do |format|
      format.json {
        render :json => {
          :exists => exists,
          :empty => empty,
          :resume_dialog_html => (exists ? resume_dialog_html(kata, live_avatar_names) : '')
        }
      }
    end
  end

  def resume_dialog_html(kata, live_avatar_names)
    @kata = kata
    @live_avatar_names = live_avatar_names
    @all_avatar_names = Avatar.names        
    filename = Rails.root.to_s + '/app/views/dojo/resume_dialog.html.erb'
    ERB.new(File.read(filename)).result(binding)    
  end
  
  #------------------------------------------------
  
  def review_json
    exists = Kata.exists?(root_dir, id)    
    respond_to do |format|
      format.json {
        render :json => {
          :exists => exists,
          :review_dialog_html => (exists ? review_dialog_html : '')          
        }
      }
    end
  end
  
  def review_dialog_html
    filename = Rails.root.to_s + '/app/views/dojo/review_dialog.html.erb'
    ERB.new(File.read(filename)).result(binding)    
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
  
private  

  def random(array)
    array.shuffle[0]
  end
  
end
