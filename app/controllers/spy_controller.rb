
class SpyController < ApplicationController

  def index
    redirect_to :action => "choose_dojo"
  end

  def choose_dojo
    @dojo_names = Dir.entries('dojos').select { |name| !dot? name }
	if @dojo_names.size == 1
	  redirect_to :action => "one_dojo", :dojo_name => @dojo_names[0]
	end
  end

  def one_dojo
    @dojo = Dojo.new(params[:dojo_name])
    @katas = []
    # TODO: dojo should now its own katas
    Dir.entries("dojos/#{@dojo.name}").select { |entry| !dot? entry }.each do |kata_name|
      kata = @dojo.kata(kata_name)
      if kata.avatars.size > 0
        @katas << kata
      end
    end
    render :layout => 'spy_one_dojo'
  end

private
  
  def dot? name
	name == '.' or name == '..'
  end

end



