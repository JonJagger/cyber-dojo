
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
    @diffed_files = git_diff_view(@avatar, params[:tag].to_i)    

    @diffs = []
    @diffed_files.each do |name,diff|
      @diffs << {
        :deleted_line_count => [0,1,2,3,4].shuffle[0],
        :name => name,
        :added_line_count => [0,1,2,3,4].shuffle[0],
        :content => git_diff_html(diff)
      }
    end
  end
  
private

  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end
  
end


