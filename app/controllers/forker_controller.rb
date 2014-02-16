
class ForkerController < ApplicationController

  def fork
    
    # TODO:
    # if language folder no longer exists
    #   return that info in JSON data
    # use that in call site
    # call site is a dialog... dialog on top of dialog?
    # http://stackoverflow.com/questions/12715579/in-jquery-ui-dialog-is-it-possible-to-put-a-modal-dialog-on-top-of-another-moda
    # add language_renames json file
    # use in controller to patch language name and do fork
    
    kata = Kata.new(root_dir, params['id'])
    avatar = Avatar.new(kata, params['avatar'])
    # gather_info requres params['language] and params['exercise']
    params['language'] = kata.language.name
    params['exercise'] = kata.exercise.name
    info = gather_info
    info[:visible_files] = avatar.visible_files(params['tag'])    
    Kata.create(root_dir, info)
    
    render :json => {
      :id => info[:id]
    }
                
  end
   
end


