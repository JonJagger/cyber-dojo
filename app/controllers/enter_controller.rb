
class EnterController < ApplicationController

  def show
    @title = 'enter'
    @id = id || ''
  end

  def check
    full_id = katas.completed(id)
    render json: {
      exists: !katas[full_id].nil?,
      full_id: full_id
    }
  end

  def start
    avatar = kata.start_avatar
    full = avatar.nil?
    render json: {
            avatar_name: !full ? avatar.name : '',
                   full:  full,
      start_dialog_html: !full ? start_dialog_html(avatar.name) : '',
       full_dialog_html:  full ? full_dialog_html : ''
    }
  end

  def continue
    render json: {
      empty: empty,
       html: continue_dialog_html
    }
  end

  private

  include EnterWorker

end
