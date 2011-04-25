
class KataController < ApplicationController

  def enter
    configure(params) 
    @dojo = Dojo.new(params)   
    manifest = @dojo.manifest
    filesets = {}
    # randonly choose kata and language from selections made at dojo creation
    filesets['kata'] = manifest[:katas].shuffle[0]
    filesets['language'] = manifest[:languages].shuffle[0]
    @avatar = Avatar.new(@dojo, params[:avatar], filesets)    
    redirect_to :action => :edit, :dojo_name => params[:dojo_name], :avatar => @avatar.name
  end    
    
  def reenter
    configure(params)
    @dojo = Dojo.new(params)
    @avatars = @dojo.avatars.map { |avatar| avatar.name }   
    render :layout => 'dashboard_view'
  end
    
  def view
    configure(params)
    params[:readonly] = true
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @kata = @avatar.kata

    @manifest = {}
    @increments = @avatar.read_manifest(@manifest, params[:tag])   
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    @outcome = @increments == [] ? '' : @increments.last[:outcome]
  end
  
  def edit
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar], params[:filesets])
    @kata = @avatar.kata

    @manifest = {}
    @increments = @avatar.read_manifest(@manifest)    
    @server_message = ""
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    @outcome = @increments == [] ? '' : @increments.last[:outcome]
  end

  def run_tests
    configure(params)
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
    configure(params)
    @dojo = Dojo.new(params)
    @server_message = @dojo.heartbeat(params[:avatar])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
private

  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end
  
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


