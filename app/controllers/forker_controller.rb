
class ForkerController < ApplicationController

  def fork    
    result = { }
    
    bad = false
    if !bad && !Kata.exists?(root_dir, params['id'])      
      result[:forked] = false
      result[:reason] = "id"
      bad = true
    end
    
    kata = Kata.new(root_dir, params['id'])
    if !bad && !Language.exists?(root_dir, kata.language.name)
      result[:forked] = false
      result[:reason] = "language"
      bad = true
    end
    
    if !bad && !kata.avatars.map{|avatar| avatar.name}.include?(params['avatar'])
      result[:forked] = false
      result[:reason] = "avatar"
      bad = true
    end

    avatar = Avatar.new(kata, params['avatar'])
    #TODO: check tag
    if !bad    
      # gather_info requres params['language] and params['exercise']
      params['language'] = kata.language.name      
      params['exercise'] = kata.exercise.name
      info = gather_info
      info[:visible_files] = avatar.visible_files(params['tag'])    
      Kata.create(root_dir, info)
      result[:forked] = true
      result[:id] = info[:id]
    end
      
    render :json => result    
  end
   
end


