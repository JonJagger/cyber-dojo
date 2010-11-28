
class KataController < ApplicationController

  def index
    @dojo = Dojo.new(params[:dojo])
    @avatars = Avatar.names   
    @filesets = FileSet.names
    
    @kata_info = {}
    FileSet.new('kata').choices.each do |name|  	
      path = RAILS_ROOT + '/' + 'filesets' + '/' + 'kata' + '/' + name + '/' + 'instructions'
   	  @kata_info[name] = IO.read(path)
    end    
  end

  def view
    @dojo = Dojo.new(params[:dojo])
    @avatar = Avatar.new(@dojo, params[:avatar], params[:filesets])
    @kata = @avatar.kata

    @manifest = {}
    @increments = @avatar.read_most_recent(@manifest)    
    @ladder = @dojo.ladder
    @rotation = @dojo.rotation(params[:avatar])
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    @outcome = @increments == [] ? '' : @increments.last[:outcome]
  end

  def run_tests
    @dojo = Dojo.new(params[:dojo])
    avatar = Avatar.new(@dojo, params[:avatar])
    manifest = load_visible_files_from_page
    @increments = avatar.run_tests(manifest)
    @output = manifest[:output]
    @ladder = @dojo.ladder_update(avatar.name, @increments.last)
    @outcome = @increments.last[:outcome]
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
  def heartbeat
    @dojo = Dojo.new(params[:dojo])
    @rotation = @dojo.rotation(params[:avatar])
    @ladder = @dojo.ladder      
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
private

  def dequote(filename)
    # <input name="file_content['wibble.h']" ...>
    # means filename has a leading ' and trailing ']
    # which need to be stripped off
    return filename[1..-2] 
  end

  def load_visible_files_from_page
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


