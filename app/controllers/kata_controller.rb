
class KataController < ApplicationController

  def enter
    params[:name] = params[:dojo]
    @dojo = Dojo.new(params)
    @filesets = FileSet.names
    
    @kata_info = {}
    FileSet.new('kata').choices.each do |name|  	
      path = RAILS_ROOT + '/' + 'filesets' + '/' + 'kata' + '/' + name + '/' + 'instructions'
   	  @kata_info[name] = IO.read(path)
    end    
  end
  
  def choose_avatar
    params[:name] = params[:dojo]
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar], params[:filesets])    
    redirect_to :action => :edit, :dojo => params[:dojo], :avatar => @avatar.name
  end
  
  def reenter
    params[:name] = params[:dojo]
    @dojo = Dojo.new(params)
    @avatars = @dojo.avatars.map { |avatar| avatar.name }   
    render :layout => 'dashboard_view'
  end
    
  def view
    redirect_to :action => :edit, :dojo => params[:dojo], :avatar => params[:avatar], :readonly => true
  end
  
  def edit
    params[:name] = params[:dojo]
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar], params[:filesets])
    @kata = @avatar.kata

    @manifest = {}
    @increments = @avatar.read_most_recent(@manifest)    
    @rotation = @dojo.rotation(params[:avatar])
    @rotation[:do_now] = false # don't rotate when re-entering
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    @outcome = @increments == [] ? '' : @increments.last[:outcome]
  end

  def run_tests
    params[:name] = params[:dojo]
    @dojo = Dojo.new(params)
    avatar = Avatar.new(@dojo, params[:avatar])
    manifest = load_visible_files_from_page
    @increments = avatar.run_tests(manifest)
    @output = manifest[:output]
    @dojo.ladder_update(avatar.name, @increments.last)
    @outcome = @increments.last[:outcome]
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
  def heartbeat
    params[:name] = params[:dojo]
    @dojo = Dojo.new(params)
    @rotation = @dojo.rotation(params[:avatar])
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


