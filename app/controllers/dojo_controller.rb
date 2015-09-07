
class DojoController < ApplicationController

  def index
    @title = 'home'
    @id = id
  end

  def check
    render json: { exists: dojo_exists }
  end

  def enter
    avatar = kata.start_avatar    
    full = avatar.nil?
    #one_self.started(avatar) if !full
    render json: {
      avatar_name: !full ? avatar.name : nil,
      full: full,
      enter_dialog_html: !full ? enter_dialog_html(avatar.name) : '',
      full_dialog_html: full ? full_dialog_html : ''
    }
  end

  def re_enter
    render json: {
      empty: empty,
      re_enter_dialog_html: dojo_exists ? re_enter_dialog_html : ''
    }
  end

private

  include DojoWorker

end
