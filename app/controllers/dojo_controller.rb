
class DojoController < ApplicationController

  def index
    @title = 'home'
    @id = id
  end

  def check
    render :json => { :exists => dojo_exists }
  end

  def enter
    avatar = dojo_exists && kata.start_avatar
    full = dojo_exists && avatar.nil?
    enter_html = dojo_exists && avatar ? enter_dialog_html(avatar.name) : ''
    full_html = full ? full_dialog_html : ''
    render :json => {
      :exists => dojo_exists,
      :id => id,
      :avatar_name => avatar ? avatar.name : nil,
      :full => full,
      :enter_dialog_html => enter_html,
      :full_dialog_html => full_html
    }
  end

  def re_enter
    render :json => {
      :exists => dojo_exists,
      :empty => empty,
      :re_enter_dialog_html => dojo_exists ? re_enter_dialog_html : ''
    }
  end

private

  include DojoWorker

end
