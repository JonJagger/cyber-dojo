
class MessagesController < ApplicationController
  
  def show_some
    board_config(params)
    @messages = @dojo.messages
    @tab_title = 'Messages'
  end

  def show_some_heartbeat
    board_config(params)
    @messages = @dojo.messages
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def show_all
    board_config(params)
    @messages = @dojo.messages
    @tab_title = 'Messages'
  end 
  
  def show_all_heartbeat
    board_config(params)
    @messages = @dojo.messages
    respond_to do |format|
      format.js if request.xhr?
    end
  end

  def post
    board_config(params)
    @messages = @dojo.post_message(params[:poster], params[:message])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
end
