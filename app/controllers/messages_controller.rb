
class MessagesController < ApplicationController
  
  def show_some
    @tab_title = 'Messages'
    board_config(params)
    @messages = @dojo.messages
  end

  def show_some_heartbeat
    board_config(params)
    @messages = @dojo.messages
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def show_all
    @tab_title = 'Messages'
    board_config(params)
    @messages = @dojo.messages
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
