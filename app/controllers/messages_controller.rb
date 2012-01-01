
class MessagesController < ApplicationController
  
  def show
    @tab_title = 'Messages'
    board_config(params)
    @messages = @dojo.messages
  end 
  
  def post
    board_config(params)
    @messages = @dojo.post_message(params[:poster], params[:message])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def post_some
    board_config(params)
    @messages = @dojo.post_message(params[:poster], params[:message])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
end
