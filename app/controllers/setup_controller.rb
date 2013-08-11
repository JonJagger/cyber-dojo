
require 'Folders'

class SetupController < ApplicationController
  
  def show
    @languages = Folders::in(root_dir + '/languages').sort    
    @exercises = Folders::in(root_dir + '/exercises').sort
    @instructions = { }
    @exercises.each do |exercise|
      @instructions[exercise] = Exercise.new(root_dir, exercise).instructions
    end
    @selected_language_index = choose_language                                               
    @selected_exercise_index = choose_exercise
    @title = 'Setup'
  end
  
  def cancel
    redirect_to :controller => 'dojo',
                :action => :index
  end

  def save
    info = gather_info
    language = Language.new(root_dir, info[:language])
    exercise = Exercise.new(root_dir, info[:exercise])
    vis = info[:visible_files] = language.visible_files
    vis['output'] = ''
    vis['instructions'] = exercise.instructions
    Kata.create(root_dir, info)
    
    redirect_to :controller => 'dojo',
                :action => :index, 
                :id => info[:id]
  end  
  
private

  def choose_language
    choice = [*0..@languages.length-1].shuffle[0]
    if params[:id] && Kata.exists?(root_dir, id)
      language_index = @languages.index(Kata.new(root_dir, id).language.name)
      if language_index != nil
        choice = language_index;
      end
    end
    choice
  end
  
  def choose_exercise
    choice = [*0..@exercises.length-1].shuffle[0]
    if params[:id] && Kata.exists?(root_dir, id)
      exercise_index = @exercises.index(Kata.new(root_dir, id).exercise.name)
      if exercise_index != nil
        choice = exercise_index
      end
    end
    choice
  end

end
