
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
  
  def valid_id
    kata = Kata.find(root_dir, id)
    exists = params[:id].length >= 6 && !kata.nil?
    started = exists ? kata.avatars.length : 0
    render :json => {
      :exists => exists,
      :started => started
    }
  end
  
  #------------------------------------------------
  
  def start_json
    kata = Kata.find(root_dir, id)
    avatar = (kata ? kata.start_avatar : nil)    
    full = kata && avatar.nil?
    start_html = kata && avatar ? start_dialog_html(avatar.name) : ''
    full_html = full ? full_dialog_html() : ''
    render :json => {
      :exists => !kata.nil?,
      :avatar_name => avatar ? avatar.name : nil,
      :full => full,
      :start_dialog_html => start_html,
      :full_dialog_html => full_html
    }
  end
  
  def start_dialog_html(avatar_name)
    @avatar_name = avatar_name
    bind('/app/views/dojo/start_dialog.html.erb')
  end
  
  def full_dialog_html()
    @all_avatar_names = Avatar.names    
    bind('/app/views/dojo/full_dialog.html.erb')
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

end
