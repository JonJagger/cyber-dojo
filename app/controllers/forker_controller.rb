
class ForkerController < ApplicationController

  def fork    
    result = { :forked => false }    
    error = false    
    kata = dojo[params['id']]
    avatar = kata[params['avatar']]
    #light = avatar.lights[params['tag']]   ?
    
    if !error && !kata.exists?
      result[:reason] = "id"
      error = true
    end
    
    if !error && !dojo.language(kata.language.name).exists?
      result[:reason] = "language"
      result[:language] = kata.language.name
      error = true
    end
    
    if !error && !avatar.exists?
      result[:reason] = "avatar"
      error = true
    end

    if !error # && !light.exists?
      traffic_lights = avatar.traffic_lights
      is_tag = params['tag'].match(/^\d+$/)
      tag = params['tag'].to_i;
      if !is_tag || tag <= 0 || tag > traffic_lights.length
        result[:reason] = "tag"
        error = true        
      end
    end

    if !error    
      manifest = make_manifest(kata.language.name, kata.exercise.name)
      manifest[:visible_files] = avatar.visible_files(params['tag'])    
      dojo.create_kata(manifest)
      result[:forked] = true
      result[:id] = manifest[:id]
    end
      
    render :json => result    
  end
   
end


