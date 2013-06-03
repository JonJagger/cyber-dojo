
require 'Locking'

class DojoController < ApplicationController
  
  def index
    @title = 'Home'
    @id = id
    @buttons = ['about','basics','donations','faqs','feedback',
                'links','source', 'recruiting', 'refactoring', 'tips','why' ]
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
    filename = Rails.root.to_s + '/app/views/dojo/start_dialog.html.erb'
    ERB.new(File.read(filename)).result(binding)
  end
  
  #------------------------------------------------
  
  def button_about;       button_dialog(450,'about'); end
  def button_basics;      button_dialog(800,'basics'); end
  def button_donations;   button_dialog(750,'donations'); end
  def button_faqs;        button_dialog(550,'faqs'); end
  def button_feedback;    button_dialog(500,'feedback'); end
  def button_links;       button_dialog(550,'links'); end
  def button_source;      button_dialog(600,'source'); end
  def button_recruiting;  button_dialog(550,'recruiting'); end
  def button_refactoring; button_dialog(500,'refactoring'); end
  def button_tips;        button_dialog(600,'tips'); end
  
  def button_dialog(size, name)
    respond_to do |format|
      format.json {
        render :json => {
          :html => bind('/app/views/dojo/button_' + name + '_dialog.html.erb'),
          :size => size
        }
      }
    end
  end
  
  def bind(filename)
    filename = Rails.root.to_s + filename
    ERB.new(File.read(filename)).result(binding)
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
  
  #------------------------------------------------

  def random(array)
    array.shuffle[0]
  end
  
end
