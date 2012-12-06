
class ForkerController < ApplicationController

  # the plan is to extend this so it provides a page showing
  # a list of visible_filenames and hidden_filenames
  # and allows you to move files from one list to the other
  # before forking.

  def fork
    kata = Kata.new(root_dir, params['id'])
    avatar = Avatar.new(kata, params['avatar'])
    # gather_info requres params['language] and params['exercise']
    params['language'] = kata.language.name
    params['exercise'] = kata.exercise.name
    info = gather_info
    info[:visible_files] = avatar.visible_files(params[:tag])    
    Kata.create_new(root_dir, info)
    
    redirect_to :controller => :dojo,
                :action => :index, 
                :id => info[:id]
  end
   
end


