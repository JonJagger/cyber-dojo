
class DiffController < ApplicationController

  def show
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @kata = @avatar.kata
    @manifest = {}
    @traffic_lights_to_tag = @avatar.read_manifest(@manifest, params[:tag])
    @all_traffic_lights = @avatar.increments    
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    @diffed_files = git_diff_view(@avatar, params[:tag].to_i)    
  end
  
  def scratch
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @kata = @avatar.kata
    @manifest = {}
    @traffic_lights_to_tag = @avatar.read_manifest(@manifest, params[:tag])
    @all_traffic_lights = @avatar.increments    
    @current_file = @manifest[:current_filename]
    @output = @manifest[:output]
    diffed_files = git_diff_view(@avatar, params[:tag].to_i)    

    @diffs = []
    diffed_files.each do |name,diff|
      n_deleted = diff.count { |line| line[:type] == :deleted }
      n_added   = diff.count { |line| line[:type] == :added }      
      @diffs << {
        :deleted_line_count => n_deleted,
        :name => name,
        :added_line_count => n_added,
        :content => git_diff_html(diff),
      }
    end
  end
  
private

  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end
  
end


