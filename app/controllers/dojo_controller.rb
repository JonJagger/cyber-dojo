
class DojoController < ApplicationController

  protect_from_forgery :only => []

  def index
    redirect_to :action => "choose_dojo", :id => params[:id]
  end

  def choose_dojo
    @dojos = Dir.entries('dojos').select { |d| d != "." and d != ".." }
  end

  def choose_kata
    @dojo_id = params[:dojo_id]
    @katas = Dir.entries("dojos/#{@dojo_id}").select { |d| d != "." and d != ".." }
  end

  def choose_avatar
    @dojo_id = params[:dojo_id]
    @kata_id = params[:kata_id]
    @avatars = Avatar.names
    @title = "Cyber Dojo"
  end

end
