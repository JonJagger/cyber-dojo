
class ForkerController < ApplicationController

  def fork
    kata = Kata.new(root_dir, params['id'])
    avatar = Avatar.new(kata, params['avatar'])
    # gather_info requres params['language] and params['exercise']
    params['language'] = kata.language.name
    params['exercise'] = kata.exercise.name
    info = gather_info
    tag = params[:tag] || avatar.traffic_lights.length;
    info[:visible_files] = avatar.visible_files(tag)    
    Kata.create(root_dir, info)
    
    redirect_to :controller => :dojo,
                :action => :index, 
                :id => info[:id]
  end
   
end


