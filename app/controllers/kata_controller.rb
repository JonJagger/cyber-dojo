
class KataController < ApplicationController

  def enter
    configure(params) 
    @dojo = Dojo.new(params)
    
    # In a multi-kata dojo, if you list the kata/language
    # filesets alphabetically there is a strong likelihood
    # each computer will simply pick the first entry. That
    # happened at the 2010 NDC conference for example. Listing 
    # them in a random order increases the chances stations
    # will make different selections, which hopefully will
    # increase the potential for collaboration - the game's
    # prime directive. 

    @katas = FileSet.new(@dojo.filesets_root, 'kata').choices.shuffle
    @languages = FileSet.new(@dojo.filesets_root, 'language').choices.shuffle
    @kata_info = {}
    @katas.each do |name|
      path = @dojo.filesets_root + '/' + 'kata' + '/' + name + '/' + 'instructions'
   	  @kata_info[name] = IO.read(path)
    end    
  end
  
  def choose_avatar
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar], params[:filesets])    
    redirect_to :action => :edit, :dojo => params[:dojo], :avatar => @avatar.name
  end
  
  def reenter
    configure(params)
    @dojo = Dojo.new(params)
    @avatars = @dojo.avatars.map { |avatar| avatar.name }   
    render :layout => 'dashboard_view'
  end
    
  def view
    redirect_to :action => :edit, :dojo => params[:dojo], :avatar => params[:avatar], :readonly => true
  end
  
  def edit
    configure(params)
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
    @rotation = @dojo.rotation(params[:avatar])
    respond_to do |format|
      format.js if request.xhr?
    end
  end
   
private

  def configure(params)
    params[:name] = params[:dojo]
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


