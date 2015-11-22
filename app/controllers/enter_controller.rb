
class EnterController < ApplicationController

  def show
    @title = 'enter'
    @id = id
  end

  def check
    render json: { exists: dojo_exists }
  end

  def join
    avatar = kata.start_avatar
    full = avatar.nil?
    #one_self.started(avatar) unless full
    render json: {
           avatar_name: !full ? avatar.name : nil,
                  full:  full,
      join_dialog_html: !full ? join_dialog_html(avatar.name) : '',
      full_dialog_html:  full ? full_dialog_html : ''
    }
  end

  def re_join
    render json: {
                     empty: empty,
      re_join_dialog_html: dojo_exists ? re_join_dialog_html : ''
    }
  end

  private

  include EnterWorker

end
