
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
    if !bad && !Language.new(root_dir, kata.language.name).exists?
      result[:forked] = false
      result[:reason] = "language"
      result[:language] = kata.language.name
      bad = true
    end
    
    if !bad && !Avatar.exists?(kata, params['avatar'])
      result[:forked] = false
      result[:reason] = "avatar"
      bad = true
    end

    if !bad
      avatar = Avatar.new(kata, params['avatar'])
      traffic_lights = avatar.traffic_lights
      is_tag = params['tag'].match(/^\d+$/)
      tag = params['tag'].to_i;
      if !is_tag || tag <= 0 || tag > traffic_lights.length
        result[:forked] = false
        result[:reason] = "tag"
        bad = true        
      end
    end

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


