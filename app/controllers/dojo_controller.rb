
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
    kata = dojo.katas[id]
    exists = params[:id].length >= 6 && kata.exists?
    started = exists ? kata.avatars.entries.length : 0
    render :json => {
      :exists => exists,
      :started => started
    }
  end

  #------------------------------------------------

  def enter_json
    kata = dojo.katas[id]
    exists = kata.exists?
    avatar = (exists ? kata.start_avatar : nil)
    full = exists && avatar.nil?
    enter_html = exists && avatar ? enter_dialog_html(avatar.name) : ''
    full_html = full ? full_dialog_html() : ''
    render :json => {
      :exists => exists,
      :avatar_name => avatar ? avatar.name : nil,
      :full => full,
      :enter_dialog_html => enter_html,
      :full_dialog_html => full_html
    }
  end

  def enter_dialog_html(avatar_name)
    @avatar_name = avatar_name
    bind('/app/views/dojo/enter_dialog.html.erb')
  end

  def full_dialog_html()
    @all_avatar_names = Avatar.names
    bind('/app/views/dojo/full_dialog.html.erb')
  end

  #------------------------------------------------

  def re_enter_json
    kata = dojo.katas[id]
    exists = kata.exists?
    started_avatar_names = exists ? kata.avatars.collect{|avatar| avatar.name} : [ ]
    empty = (started_avatar_names == [ ])
    render :json => {
      :exists => exists,
      :empty => empty,
      :re_enter_dialog_html => (exists ? re_enter_dialog_html(kata, started_avatar_names) : '')
    }
  end

  def re_enter_dialog_html(kata, started_avatar_names)
    @kata = kata
    @started_avatar_names = started_avatar_names
    @all_avatar_names = Avatar.names
    bind('/app/views/dojo/re_enter_dialog.html.erb')
  end

end
