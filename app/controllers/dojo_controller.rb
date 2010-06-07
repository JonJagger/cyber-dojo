
class DojoController < ApplicationController

  protect_from_forgery :only => []

  def index
    redirect_to :action => "choose_dojo", :id => params[:id]
  end

  def choose_dojo
    @dojos = Dir.entries('dojos').select { |name| !dot? name }
	if @dojos.size == 1
	  redirect_to :action => "choose_avatar", :dojo_id => @dojos[0]
	end
  end

  def choose_avatar
    @dojo_id = params[:dojo_id]
    @avatars = Avatar.names
  end

  def choose_kata
    @dojo_id = params[:dojo_id]
    @avatar = params[:avatar]
    @katas = Dir.entries("dojos/#{@dojo_id}").select { |name| !dot? name }
  end

private

  def dot? name
	name == '.' or name == '..'
  end

end
