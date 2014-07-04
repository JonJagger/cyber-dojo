require_relative '../../lib/UniqueId'

class ForkerController < ApplicationController

  def fork
    result = { :forked => false }
    error = false

    id = params['id']
    if !error
      if !dojo.katas.exists?(id)
        error = true
        result[:reason] = 'id'
      else
        kata = dojo.katas[id]
      end
    end

    if !error
      if !dojo.languages[kata.language.name].exists?
        error = true
        result[:reason] = 'language'
        result[:language] = kata.language.name
      end
    end

    avatar_name = params['avatar']
    if !error
      avatar = kata.avatars[avatar_name]
      if !error && !avatar.exists?
        result[:reason] = 'avatar'
        error = true
      end
    end

    #tag = avatar.tags[params['tag']]
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
      id = unique_id
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

private

  include UniqueId

end
