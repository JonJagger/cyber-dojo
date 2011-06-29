require 'ids'
require 'GitDiff'

class DiffController < ApplicationController

  include Ids
  include GitDiff
  
  def show
    configure(params)
    @dojo = Dojo.new(params)
    @avatar = Avatar.new(@dojo, params[:avatar])
    @kata = @avatar.kata
    tag = params[:tag].to_i
    manifest = {}
    @traffic_lights_to_tag = @avatar.read_manifest(manifest, tag)
    @all_traffic_lights = @avatar.increments    
    @output = manifest[:output]
    @diffs = []
    generate = IdGenerator.new("jj")
    diffed_files = git_diff_view(@avatar, tag)
    diffed_files.sort.each do |name,diff|
      id = generate.id      
      @diffs << {
        :deleted_line_count => diff.count { |line| line[:type] == :deleted },
        :id => id,          
        :name => name,
        :added_line_count => diff.count { |line| line[:type] == :added },
        :content => git_diff_html(diff),
      }
    end
    # Now that 'output' is not a separate textarea but a pseudo filename
    # the current file is always 'output'
    # Revisit this... Perhaps choose the file with the most diffs?
    @current_filename_id = @diffs.find {|diff| diff[:name] == manifest[:current_filename]}[:id]
  end
  
private

  def configure(params)
    params[:dojo_root] = RAILS_ROOT + '/' + 'dojos' 
    params[:filesets_root] = RAILS_ROOT + '/' + 'filesets'
  end
  
end


