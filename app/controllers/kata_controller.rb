
class KataController < ApplicationController

  def start
    @kata = Kata.new(params[:kata_id], params[:avatar])
    @title = "Cyber Dojo : Kata " + @kata.id + ", " + @kata.avatar.name

    @manifest = load_starting_manifest(@kata)
    @increments = []
    File.open(@kata.folder, 'r') do |f|
      flock(f) do |lock|
        @increments = @kata.avatar.read_most_recent(@manifest)
      end
    end

    @shown_increment_number = @increments.length
  end

  def run_tests
    @kata = Kata.new(params[:kata_id], params[:avatar]) 
    @kata.run_tests(load_files_from_page, params['run_tests_prediction'])
    @increments = @kata.avatar.increments
    @shown_increment_number = @increments.length

    respond_to do |format|
      format.js if request.xhr?
    end
  end

  def see_all_increments
    @kata = Kata.new(params[:id])
    @kata.readonly = true
    @title = "Cyber Dojo : Kata " + @kata.id
  end

  def see_one_increment
    @kata = Kata.new(params[:id], params[:avatar])
    @kata.readonly = true
    @shown_increment_number = params[:increment].to_i
    @title = "Cyber Dojo : Kata " + @kata.id + "," + @kata.avatar.name +
       ", increment " + @shown_increment_number.to_s

    @manifest = @kata.avatar.visible_files(@shown_increment_number)
    @increments = [ @kata.avatar.increments[@shown_increment_number] ]
  end

private

  def load_starting_manifest(kata)
    catalogue = eval IO.read(kata.folder + '/' + 'kata_manifest.rb')
    manifest_folder = 'languages' + '/' + catalogue[:language]
    manifest = eval IO.read(manifest_folder + '/' + 'exercise_manifest.rb')
    manifest[:language] = catalogue[:language]
    # this is to load file content
    manifest[:visible_files] = kata.exercise.visible_files    
    manifest
  end

  def load_files_from_page
    manifest = {}
    # filenames in the file-list may have been renamed or deleted so reload visible_files
    manifest[:visible_files] = {}
    filenames = params['visible_filenames_container'].strip.split(';')
    filenames.each do |filename|
      filename.strip!
      if (filename != "")
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

#=========================================================================

def limited(increments)
  max_increments_displayed = 51
  len = [increments.length, max_increments_displayed].min
  increments[-len,len]
end


