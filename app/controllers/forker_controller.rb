
class ForkerController < ApplicationController

  def fork    
    result = { }    
    bad = false
    
    kata = dojo[params['id']]
    
    if !bad && !kata.exists?      
      result[:forked] = false
      result[:reason] = "id"
      bad = true
    end
    
    if !bad && !dojo.language(kata.language.name).exists?
      result[:forked] = false
      result[:reason] = "language"
      result[:language] = kata.language.name
      bad = true
    end
    
    if !bad && !Avatar.new(kata, params['avatar']).exists?
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
      manifest = make_manifest(kata.language.name, kata.exercise.name)
      manifest[:visible_files] = avatar.visible_files(params['tag'])    
      dojo.create_kata(manifest)
      result[:forked] = true
      result[:id] = manifest[:id]
    end
      
    render :json => result    
  end
   
end


