
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
    @increments = @avatar.read_most_recent(@manifest)
  end

  def run_tests
    @dojo = Dojo.new(params[:dojo_name])
    @kata = @dojo.new_kata(params[:kata_name])
    @avatar = @kata.new_avatar(params[:avatar_name])
    @avatar.run_tests(load_files_from_page);
    @increments = @avatar.increments
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
private

  def load_files_from_page
    manifest = { :visible_files => {} }
    filenames = params['visible_filenames_container'].strip.split(';')
    filenames.each do |filename|
      filename.strip!
      if filename != ""
        manifest[:visible_files][filename] = {}
        # TODO: creating a new file and then immediately deleting it
        #       causes params[filename] to be be nil for some reason
        #       I haven't yet tracked down.
        
        if content = params[filename]
          manifest[:visible_files][filename][:content] = content.split("\r\n").join("\n")
        end
      end
    end
    manifest
  end

end




