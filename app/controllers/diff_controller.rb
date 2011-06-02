
class DiffController < ApplicationController

  def show
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
    @diffed_files = git_diff_view(@avatar, params[:tag].to_i)    
  end
  
  def scratch
    @diffs = [
      { :deleted_line_count => 2, :name => 'gapper.rb',     :added_line_count => 1, :content => "X" },
      { :deleted_line_count => 1, :name => 'pairs.rb',      :added_line_count => 4, :content => "Y" },
      { :deleted_line_count => 0, :name => 'test_pairs.rb', :added_line_count => 3, :content => "Z" },
    ]
  end
  
private

  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end
  
end


