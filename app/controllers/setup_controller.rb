
require 'Folders'
require 'Choose'

class SetupController < ApplicationController
  
  def show
    @languages = Folders::in(dojo.dir + '/languages').sort    
    @exercises = Folders::in(dojo.dir + '/exercises').sort
    @instructions = { }
    @exercises.each do |name|
      @instructions[name] = dojo.exercise(name).instructions
    end
    @selected_language_index = Choose::language(@languages, params[:id], id, dojo.dir)                                              
    @selected_exercise_index = Choose::exercise(@exercises, params[:id], id, dojo.dir)
    @id = id
    @title = 'Setup'
  end

  def save
    manifest = make_manifest(params['language'], params['exercise'])
    language = dojo.language(manifest[:language])
    exercise = dojo.exercise(manifest[:exercise])
    vis = manifest[:visible_files] = language.visible_files
    vis['output'] = ''
    vis['instructions'] = exercise.instructions
    dojo.create_kata(manifest)
    
    logger.info("Created dojo " + manifest[:id] +
                ", " + language.name +
                ", " + exercise.name +
                ", " + make_time(Time.now).to_s)

    render :json => {
      :id => manifest[:id]
    }    
  end  

end
