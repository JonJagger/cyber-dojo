
class KataController < ApplicationController

  def index
    @dojo = Dojo.new(params[:dojo])
    @avatars = Avatar.names   
    @filesets = FileSet.names
  end

  def view
  	@dojo = Dojo.new(params[:dojo])
    @avatar = Avatar.new(@dojo, params[:avatar], params[:filesets])
    @kata = @avatar.kata

    @manifest = {}
    all_increments = @avatar.read_most_recent(@kata, @manifest)
    @increments = limited(all_increments)
    @money_ladder = @dojo.money_ladder
    @rotation = @dojo.rotation(params[:avatar])
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    @outcome = @increments == [] ? '' : @increments.last[:outcome]
  end

  def run_tests
    @dojo = Dojo.new(params[:dojo])
    avatar = Avatar.new(@dojo, params[:avatar], nil)
    kata = avatar.kata

    @output = avatar.run_tests(kata, load_visible_files_from_page)
    @increments = limited(avatar.increments)
    @money_ladder = @dojo.money_ladder_update(avatar.name, @increments.last)
    @outcome = @increments.last[:outcome]
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def money_ladder
    @dojo = Dojo.new(params[:dojo])  # @dojo.name needed for bank button
    @money_ladder = @dojo.money_ladder      
    respond_to do |format|
      format.js if request.xhr?
    end
  end

  def rotation
  	dojo = Dojo.new(params[:dojo])
  	@rotation = dojo.rotation(params[:avatar])
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

  def limited(increments)
  	max_increments_displayed = 7
  	len = [increments.length, max_increments_displayed].min
  	increments[-len,len]
	end

end


