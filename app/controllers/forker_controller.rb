
class ForkerController < ApplicationController

  def fork
    result = { :forked => false }
    error = false

    kata = dojo.katas[params['id']]
    avatar = kata.avatars[params['avatar']]

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
      traffic_lights = avatar.traffic_lights
      is_tag = params['tag'].match(/^\d+$/)
      tag = params['tag'].to_i;
      if !is_tag || tag <= 0 || tag > traffic_lights.length
        result[:reason] = 'tag'
        error = true
      end
    end

    if !error
      language = kata.language
      exercise = kata.exercise
      id = Uuid.new.to_s
      now = make_time(Time.now)
      manifest = @paas.make_kata_manifest(dojo, language, exercise, id, now)
      manifest[:visible_files] = avatar.visible_files(params['tag'])
      kata = Kata.new(dojo, id)
      paas.disk_make_dir(kata)
      paas.disk_write(kata, kata.manifest_filename, manifest)
      result[:forked] = true
      result[:id] = id
    end

    render :json => result
  end

end
