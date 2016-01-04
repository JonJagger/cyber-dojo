
class EnterController < ApplicationController

  def show
    @title = 'enter'
    @id = id
  end

  def check
    render json: { exists: dojo_exists }
  end

  def start
    name = dojo.history.kata_start_avatar(kata, Avatars.names.shuffle)
    full = name.nil?
    render json: {
            avatar_name: !full ? name : nil,
                   full:  full,
      start_dialog_html: !full ? start_dialog_html(name) : '',
       full_dialog_html:  full ? full_dialog_html : ''
    }
  end

  def continue
    render json: { empty: empty, html: continue_dialog_html }
  end

  private

  include EnterWorker

end
