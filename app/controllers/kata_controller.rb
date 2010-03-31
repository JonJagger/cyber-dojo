
class KataController < ApplicationController

  def start
    @dojo = Dojo.new(params[:dojo_id])
    @kata = @dojo.kata(params[:kata_id], params[:avatar])
    @title = "Cyber-Dojo=" + @dojo.id + ", Kata=" + @kata.id + ", Avatar=" + @kata.avatar.name
    @manifest = {}
    @increments = @kata.avatar.read_most_recent(@manifest)
    @shown_increment_number = @increments.length
  end

  def run_tests
    @dojo = Dojo.new(params[:dojo_id])
    @kata = @dojo.kata(params[:kata_id], params[:avatar])
    @kata.run_tests(load_files_from_page, params[:run_tests_prediction])
    @increments = @kata.avatar.increments
    @shown_increment_number = @increments.length
    respond_to do |format|
      format.js if request.xhr?
    end
  end

  def see_all_increments
    @dojo = Dojo.new(params[:id])
    @kata = @dojo.kata(params[:kata_id], readonly = true)
    @title = "Cyber-Dojo=" + @dojo.id + ", Kata=" + @kata.id
  end

  def see_one_increment
    @dojo = Dojo.new(params[:id])
    @kata = @dojo.kata(params[:kata_id], params[:avatar], readonly = true)
    @shown_increment_number = params[:increment].to_i
    @title = "Cyber-Dojo=" + @dojo.id + ", Kata=" + @kata.id + ", Avatar=" + @kata.avatar.name +
       ", Increment=" + @shown_increment_number.to_s
    @manifest = @kata.avatar.visible_files(@shown_increment_number)
    @increments = [ @kata.avatar.increments[@shown_increment_number] ]
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

def limited(increments)
  max_increments_displayed = 49
  len = [increments.length, max_increments_displayed].min
  increments[-len,len]
end


