
class KataController < ApplicationController

  def index
    @dojo = Dojo.new(params[:dojo_name])
    @avatar_name = params[:avatar_name]
  end

  def view
    @dojo = Dojo.new(params[:dojo_name])
    @kata = @dojo.new_kata(params[:kata_name])
    @avatar = @kata.new_avatar(params[:avatar_name])
    @manifest = {}
    @increments = limited(@avatar.read_most_recent(@manifest))
    @current_file = @manifest[:current_filename] || 'cyberdojo.sh'
    @output = @manifest[:output] || welcome_text
    @output_outcome = @increments == [] ? '' : @increments.last[:outcome]
  end

  def run_tests
    dojo = Dojo.new(params[:dojo_name])
    kata = dojo.new_kata(params[:kata_name])
    avatar = kata.new_avatar(params[:avatar_name])
    @output = avatar.run_tests(load_files_from_page)
    @increments = limited(avatar.increments)
    @output_outcome = @increments.last[:outcome]
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
private

  def welcome_text
    [ 'Welcome.',
      '',
      'In a CyberDojo you practice the collaborative game',
      'called software development!',
      '',      
      'Clicking the play> button runs cyberdojo.sh on the',
      'CyberDojo server and displays its output here.',
      '',
      'The Only CyberDojo Rule',
      '-----------------------',
      'When you hear the bell each keyboard driver must move',
      'to another laptop and take up a non-driver role.',
    ].join("\n")
  end

  def dequote(filename)
    # <input name="file_content['wibble.h']" ...>
    # means filename has a leading and trailing single quote
    # which needs to be stripped off (and also a trailing ])
    return filename[1..-2] 
  end

  def load_files_from_page
    manifest = { :visible_files => {} }

    (params[:file_content] || {}).each do |filename,content|
      filename = dequote(filename)
      manifest[:visible_files][filename] = {}
      manifest[:visible_files][filename][:content] = content.split("\r\n").join("\n")  
    end

    (params[:file_caret_pos] || {}).each do |filename,caret_pos|
      filename = dequote(filename)
      manifest[:visible_files][filename][:caret_pos] = caret_pos
    end

    manifest[:current_filename] = params['filename']

    manifest
  end

end

def limited(increments)
  max_increments_displayed = 5
  len = [increments.length, max_increments_displayed].min
  increments[-len,len]
end




