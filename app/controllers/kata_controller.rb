
require 'CodeRunner'
require 'CodeOutputParser'

class KataController < ApplicationController
    
  def edit
    @kata = Kata.new(root_dir, id)
    @avatar = Avatar.new(@kata, params[:avatar])
    @tab = @kata.tab    
    @visible_files = @avatar.visible_files
    @output = @visible_files['output']
    @title = 'Run Tests'
  end

  def run_tests
    @kata = Kata.new(root_dir, id)
    @avatar = Avatar.new(@kata, params[:avatar])
        
    sandbox_dir = root_dir + '/sandboxes/' + `uuidgen`.strip.delete('-')[0..9]    
    #language_dir = root_dir +  '/languages/' + @kata.language
    language = Language.new(root_dir, @kata.language)
    
    @output = CodeRunner::run(sandbox_dir, language, visible_files)
    inc = CodeOutputParser::parse(@kata.unit_test_framework, @output)
    @avatar.save_run_tests(visible_files, @output, inc)
    
    respond_to do |format|
      format.js if request.xhr?
    end        
  end
      
private

  def visible_files
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


