
class DojoController < ApplicationController

  def index
    @title = 'home'
    @id = id
  end

  #------------------------------------------------

  def check_id
    render :json => {
      :exists => exists
    }
  end

  #------------------------------------------------

  def enter
    avatar = (exists ? kata.start_avatar : nil)
    full = exists && avatar.nil?
    enter_html = exists && avatar ? enter_dialog_html(avatar.name) : ''
    full_html = full ? full_dialog_html() : ''
    render :json => {
      :exists => exists,
      :id => id,
      :avatar_name => avatar ? avatar.name : nil,
      :full => full,
      :enter_dialog_html => enter_html,
      :full_dialog_html => full_html
    }
  end

private

  def exists
    @exists ||= katas.exists?(id)
  end

  def enter_dialog_html(avatar_name)
    @avatar_name = avatar_name
    bind('/app/views/dojo/enter_dialog.html.erb')
  end

  def full_dialog_html()
    @all_avatar_names = Avatars.names
    bind('/app/views/dojo/full_dialog.html.erb')
  end

  def bind(pathed_filename)
    filename = Rails.root.to_s + pathed_filename
    ERB.new(File.read(filename)).result(binding)
  end

end
