
require 'Folders'
require 'Choose'

class SetupController < ApplicationController
  
  def show
    @languages = Folders::in(root_dir + '/languages').sort    
    @exercises = Folders::in(root_dir + '/exercises').sort
    @instructions = { }
    @exercises.each do |exercise|
      @instructions[exercise] = Exercise.new(root_dir, exercise).instructions
    end
    @selected_language_index = Choose::language(@languages, params[:id], id, root_dir)                                              
    @selected_exercise_index = Choose::exercise(@exercises, params[:id], id, root_dir)
    @id = id
    @title = 'Setup'
  end

  def save
    info = gather_info
    language = Language.new(root_dir, info[:language])
    exercise = Exercise.new(root_dir, info[:exercise])
    vis = info[:visible_files] = language.visible_files
    vis['output'] = ''
    vis['instructions'] = exercise.instructions
    Kata.create(root_dir, info)
    
    logger.warn("Created dojo " + info[:id] +
                ", " + language.name +
                ", " + exercise.name +
                ", " + make_time(Time.now).to_s)

    render :json => {
      :id => info[:id]
    }    
  end  

end
