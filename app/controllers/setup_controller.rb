
require 'Folders'

class SetupController < ApplicationController
  
  def show
    @languages = Folders::in(root_dir + '/languages').sort    
    @exercises = Folders::in(root_dir + '/exercises').sort
    @instructions = { }
    @exercises.each do |exercise|
      @instructions[exercise] = Exercise.new(root_dir, exercise).instructions
    end
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
  
end
