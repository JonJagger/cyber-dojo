
class ForkerController < ApplicationController

  def fork
    result = { forked: false }
    error = false

    if !error && kata.nil?
      error = true
      result[:reason] = "dojo(#{id})"
    end

    if !error && kata.language.nil?
      error = true
      result[:reason] = "language(#{kata.language_name})"
    end

    if !error && avatar.nil?
      error = true
      result[:reason] = "avatar(#{avatar_name})"
    end

    #tag = avatar.tags[params['tag']]
    if !error # && !light.exists?
      is_tag = params['tag'].match(/^\d+$/)
      tag = params['tag'];
      if !is_tag || tag.to_i <= 0 || tag.to_i > avatar.lights.count
        error = true
        result[:reason] = "traffic_light(#{tag})"
      end
    end

    if !error
      language = kata.language
      tag = params['tag'].to_i
      id = unique_id

      # don't use kata.exercise.name because
      # the exercise might have been renamed
      exercise_name = kata.exercise_name

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
      dojo.history.create_kata(forked_kata, manifest)
      result[:forked] = true
      result[:id] = id
    end

    respond_to do |format|
      format.json { render json: result }
      format.html { redirect_to controller: 'enter',
                                    action: 'show',
                                        id: result[:id] }
    end
  end

  private

  include UniqueId
  include TimeNow

end

