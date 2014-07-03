
class ForkerController < ApplicationController

  def fork
    result = { :forked => false }
    error = false

    kata = dojo.katas[params['id']]
    avatar = kata.avatars[params['avatar']]
    #tag  = avatar.tags[params['tag']]
    
    if !error && !kata.exists?
      result[:reason] = 'id'
      error = true
    end

    if !error && !dojo.languages[kata.language.name].exists?
      result[:reason] = 'language'
      result[:language] = kata.language.name
      error = true
    end

    if !error && !avatar.exists?
      result[:reason] = 'avatar'
      error = true
    end

    if !error # && !light.exists?
      is_tag = params['tag'].match(/^\d+$/)
      tag = params['tag'].to_i;
      if !is_tag || tag <= 0 || tag > avatar.lights.length
        result[:reason] = 'tag'
        error = true
      end
    end

    if !error
      language = dojo.languages[kata.language.name]
      exercise = kata.exercise
      id = Id.new.to_s
      now = make_time(Time.now)
      manifest = dojo.katas.create_kata_manifest(language, exercise, id, now)
      tag = params['tag'].to_i
      manifest[:visible_files] = avatar.tags[tag].visible_files
      kata = dojo.katas[id]
      kata.dir.write('manifest.json', manifest)
      result[:forked] = true
      result[:id] = id
    end

    respond_to do |format|
      format.json { render :json => result }
      format.html { redirect_to :controller => 'dojo',
                                :action => 'index',
                                :id => result[:id] }
    end

  end

end
