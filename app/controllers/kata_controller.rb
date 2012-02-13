
class KataController < ApplicationController
  
  def edit
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @tab = @dojo.tab    
    @messages = @dojo.messages
    @manifest = @avatar.manifest
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    @tab_title = 'Run Tests'
  end

  def run_tests
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    manifest = load_manifest_from_page()
    @avatar.run_tests(manifest)
    @output = manifest[:output]
    @avatar.post_run_test_messages()
    @messages = @dojo.messages
    respond_to do |format|
      format.js if request.xhr?
    end        
  end
   
  def heartbeat
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @avatar.post_heartbeat_messages()
    @messages = @dojo.messages
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
private

  def dequote(filename)
    # <input name="file_content['wibble.h']" ...>
    # means filename has a leading ' and trailing '
    # which need to be stripped off
    return filename[1..-2] 
  end

  def load_manifest_from_page
    manifest = { :visible_files => {} }
    (params[:file_content] || {}).each do |filename,content|
      filename = dequote(filename)
      # Cater for windows line endings from windows browser
      manifest[:visible_files][filename] = content.gsub(/\r\n/, "\n")  
    end
 
    manifest[:current_filename] = params['current_filename']

    manifest
  end

end


