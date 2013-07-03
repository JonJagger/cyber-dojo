
class DojoController < ApplicationController
  
  def index
    @title = 'Home'
    @id = id
  end
 
  def button_dialog
    name = params[:id]
    render :partial => "/dojo/dialog_#{name}",
           :layout => false
  end
 
  #------------------------------------------------
  
  def start_json
    kata = Kata.find(root_dir, id)
    avatar = (kata ? kata.start_avatar : nil)    
    full = kata && avatar.nil?
    html = kata && avatar ? start_dialog_html(avatar.name) : ''    
    render :json => {
      :exists => !kata.nil?,
      :avatar_name => avatar ? avatar.name : nil,
      :full => full,
      :start_dialog_html => html
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

end
