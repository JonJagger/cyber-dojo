
class ForkerController < ApplicationController

  def fork
    result = { forked: false }
    error = false

    if !error && kata.nil?
      error = true
      result[:reason] = 'dojo'
      result[:dojo] = id
    end

    if !error && kata.language.nil?
      error = true
      result[:reason] = 'language'
      result[:language] = kata.manifest['language']
    end

    if !error && avatar.nil?
      error = true
      result[:reason] = 'avatar'
      result[:avatar] = avatar_name
    end

    #tag = avatar.tags[params['tag']]
    if !error # && !light.exists?
      is_tag = params['tag'].match(/^\d+$/)
      tag = params['tag'].to_i;
      if !is_tag || tag <= 0 || tag > avatar.lights.count
        error = true
        result[:reason] = 'traffic_light'
        result[:traffic_light] = tag
      end
    end

    if !error
      language = kata.language
      tag = params['tag'].to_i
      id = unique_id

      # don't use kata.exercise.name because
      # exercise might have been renamed
      exercise_name = kata.manifest['exercise']

      manifest = {
                    created: time_now,
                         id: id,
                   language: language.name,
                   exercise: exercise_name,
        unit_test_framework: language.unit_test_framework,
                   tab_size: language.tab_size,
              visible_files: avatar.tags[tag].visible_files
      }

      forked_kata = Kata.new(katas, id)
      disk[forked_kata.path].make
      disk[forked_kata.path].write_json('manifest.json', manifest)
      result[:forked] = true
      result[:id] = id
    end

    respond_to do |format|
      format.json { render json: result }
      format.html { redirect_to controller: 'dojo',
                                    action: 'index',
                                        id: result[:id] }
    end
  end

  private

  include UniqueId
  include TimeNow

end

