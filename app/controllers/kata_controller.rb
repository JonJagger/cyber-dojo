
require 'CodeRunner'
require 'CodeOutputParser'
require 'make_time_helper.rb'

class KataController < ApplicationController
    
  include MakeTimeHelper
  
  def edit
    configure(params)
    @kata = Kata.new(params)
    @avatar = Avatar.new(@kata, params[:avatar])
    @tab = @kata.tab    
    @visible_files = @avatar.visible_files
    @output = @visible_files['output']
    @title = 'Run Tests'
  end

  def run_tests
    configure(params)
    @kata = Kata.new(params)
        
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    language = @kata.language
    
    sandbox_dir = RAILS_ROOT + '/code_runner/' + temp_dir
    language_dir = RAILS_ROOT +  '/filesets/language/' + language    
    visible_files = get_visible_files
    
    @output = CodeRunner::run(sandbox_dir, language_dir, visible_files)
    
    visible_files['output'] = @output
    inc = CodeOutputParser::parse(@kata.unit_test_framework, @output)
    inc[:time] = make_time(Time::now)
    
    @avatar = Avatar.new(@kata, params[:avatar])
    @avatar.save_run_tests(visible_files, inc)
    
    respond_to do |format|
      format.js if request.xhr?
    end        
  end
      
private

  def get_visible_files
    seen = { }
    (params[:file_content] || {}).each do |filename,content|
      # Cater for windows line endings from windows browser
      seen[dequote(filename)] = content.gsub(/\r\n/, "\n")  
    end
    seen
  end

  def dequote(filename)
    # <input name="file_content['wibble.h']" ...>
    # means filename has a leading ' and trailing '
    # which need to be stripped off
    return filename[1..-2] 
  end

end


