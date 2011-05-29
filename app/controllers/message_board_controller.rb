
class MessageBoardController < ApplicationController
 
  def show_some
    board_config(params)
    @messages = @dojo.messages
  end

  def heartbeat
    board_config(params)
    @messages = @dojo.messages
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def show_all
    board_config(params)
    @messages = @dojo.messages
  end 
  
  def post_message
    configure(params)
    @dojo = Dojo.new(params)
    @messages = @dojo.post_message(params[:avatar], params[:message])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
private

  def dojo_name
    params[:dojo_name]
  end
  
  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end

  def board_config(params)
    configure(params)
    @dojo = Dojo.new(params)
    avatars = @dojo.avatars
    @languages = avatars.collect { |avatar| avatar.kata.language }.uniq
    @katas = avatars.collect { |avatar| avatar.kata.name }.uniq    
  end
  
end
