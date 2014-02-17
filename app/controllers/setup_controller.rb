
require 'Folders'
require 'Choose'

class SetupController < ApplicationController
  
  def show
    @languages = Folders::in(cd.dir + '/languages').sort    
    @exercises = Folders::in(cd.dir + '/exercises').sort
    @instructions = { }
    @exercises.each do |name|
      @instructions[name] = cd.exercise(name).instructions
    end
    @selected_language_index = Choose::language(@languages, params[:id], id, cd.dir)                                              
    @selected_exercise_index = Choose::exercise(@exercises, params[:id], id, cd.dir)
    @id = id
    @title = 'Setup'
  end

  def save
    info = gather_info
    language = cd.language(info[:language])
    exercise = cd.exercise(info[:exercise])
    vis = info[:visible_files] = language.visible_files
    vis['output'] = ''
    vis['instructions'] = exercise.instructions
    cd.create_kata(info)
    
    logger.info("Created dojo " + info[:id] +
                ", " + language.name +
                ", " + exercise.name +
                ", " + make_time(Time.now).to_s)

    render :json => {
      :id => info[:id]
    }    
  end  

end
