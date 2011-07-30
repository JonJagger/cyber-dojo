
class KataController < ApplicationController

  def enter
    configure(params) 
    @dojo = Dojo.new(params)   
    @avatar = @dojo.create_avatar
    if @avatar == nil
      flash[:notice] = 'Sorry, the CyberDojo named ' + @dojo.name + ' is full'
      redirect_to :controller => :dojo, :action => :index, :dojo_name => @dojo.name
    else
      redirect_to :action => :edit, :dojo_name => params[:dojo_name], :avatar => @avatar.name
    end
  end    
 
  def edit
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @tab = @avatar.kata.tab    
    @messages = @dojo.messages
    @manifest = @avatar.manifest
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
  end

  def run_tests
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])   
    manifest = load_visible_files_from_page
    @avatar.run_tests(manifest)
    @output = manifest[:output]
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
  def heartbeat
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])   
    @messages = @dojo.messages
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


