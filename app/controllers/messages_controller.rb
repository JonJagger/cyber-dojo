
class MessagesController < ApplicationController
  
  def show
    @title = 'Messages'
    board_config(params) # TODO: needed?
    @messages = @kata.messages
    @id = id
  end 
  
  def post
    board_config(params)
    @messages = @kata.post_message(params[:poster], params[:message])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def post_some
    board_config(params)
    @messages = @kata.post_message(params[:poster], params[:message])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
end
