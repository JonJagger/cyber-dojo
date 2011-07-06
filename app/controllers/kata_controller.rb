
class KataController < ApplicationController

  def enter
    configure(params) 
    @dojo = Dojo.new(params)   
    manifest = @dojo.manifest
    # randonly choose kata and language from selections made at dojo creation
    if manifest[:katas].length > 1 or manifest[:languages].length > 1 
      redirect_to :action => :select, :dojo_name => params[:dojo_name]
    else
      
      filesets = {
        'kata' => manifest[:katas][0],
        'language' => manifest[:languages][0]
      }    
      @avatar = @dojo.create_avatar(filesets)    
      if @avatar == nil
        flash[:notice] = 'Sorry, the CyberDojo named ' + @dojo.name + ' is full'
        redirect_to :controller => :dojo, :action => :index, :dojo_name => @dojo.name
      else
        redirect_to :action => :edit, :dojo_name => params[:dojo_name], :avatar => @avatar.name
      end
    end
  end    

  def enter_selected
    configure(params) 
    @dojo = Dojo.new(params)   
    manifest = @dojo.manifest
    filesets = {
      'kata' => params[:kata],
      'language' => params[:language]
    }
    @avatar = @dojo.create_avatar(filesets)    
    if @avatar == nil
      flash[:notice] = 'Sorry, the CyberDojo named ' + @dojo.name + ' is full'
      redirect_to :controller => :dojo, :action => :index, :dojo_name => @dojo.name
    else
      redirect_to :action => :edit, :dojo_name => params[:dojo_name], :avatar => @avatar.name
    end
  end
  
  def select
    configure(params) 
    @dojo = Dojo.new(params)   
    manifest = @dojo.manifest
    @katas = manifest[:katas]
    @languages = manifest[:languages]
  end
  
  def review
    configure(params)
    params[:readonly] = true
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @kata = @avatar.kata
    @manifest = {}
    @traffic_lights_to_tag = @avatar.read_manifest(@manifest, params[:tag])
    @all_traffic_lights = @avatar.increments    
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
  end
  
  def edit
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar], params[:filesets])
    @kata = @avatar.kata    
    @messages = @dojo.messages
    @manifest = {}
    @traffic_lights = @avatar.read_manifest(@manifest)  #are traffic_lights NEEDED?
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
  end

  def run_tests
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @kata = @avatar.kata    
    manifest = load_visible_files_from_page
    @traffic_lights = @avatar.run_tests(manifest)
    @output = manifest[:output]
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
  def heartbeat
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @kata = @avatar.kata    
    @messages = @dojo.messages
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
      manifest[:visible_files][filename] ||= {}
      # Cater for windows line endings from windows browser
      manifest[:visible_files][filename][:content] = content.gsub(/\r\n/, "\n")  
    end
 
    (params[:file_caret_pos] || {}).each do |filename,caret_pos|
      filename = dequote(filename)
      manifest[:visible_files][filename][:caret_pos] = caret_pos
    end

    (params[:file_scroll_top] || {}).each do |filename,scroll_top|
      filename = dequote(filename)
      manifest[:visible_files][filename][:scroll_top] = scroll_top
    end
    (params[:file_scroll_left] || {}).each do |filename,scroll_left|
      filename = dequote(filename)
      manifest[:visible_files][filename][:scroll_left] = scroll_left
    end
    
    manifest[:current_filename] = params['current_filename']

    manifest
  end

end


