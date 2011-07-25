require 'test_helper'
require 'recent_helper'
require 'GitDiffParser'

# > cd cyberdojo/test
# > ruby functional/diff_tag_bug_trap_tests.rb

class DiffTagBugTrapTests < ActionController::TestCase
  
  # There were two bugs in the diff-view code
  # related to a renamed file and a deleted file
  # I used these these tests to track them down.
  # I added specific tests in git_diff_parser_tests.rb
  # so the tests are commented out as they take quite
  # a while to run over numerous dojos
  
  include RecentHelper
  include Ids
  include GitDiff

  # I used this to check individual tags
  def X_test_look_for_tag_bug
    params = { 
      :dojo_name => 'ruby-gapper', 
      :dojo_root => Dir.getwd + '/../dojos',
      :filesets_root => Dir.getwd + '/../filesets'
    }      
    dojo = Dojo.new(params)
    avatar = Avatar.new(dojo, 'elephant')
    look_for_diff_bug_in_traffic_light(dojo,avatar,153)   
  end

  # I used this to check all tags on an all dojos
  def X_test_look_for_diff_tag_bugs_in_entire_dojo    
    index = eval IO.popen('cat ../dojos/index.rb').read
    index.each {|e| look_for_diff_tag_bug_in_dojo(e[:name]) }
  end
  
  def look_for_diff_tag_bug_in_dojo(name)
    p name    
    params = { 
      :dojo_name => name, 
      :dojo_root => Dir.getwd + '/../dojos',
      :filesets_root => Dir.getwd + '/../filesets'
    }      
    dojo = Dojo.new(params)
    dojo.avatars.each do |avatar|
      look_for_diff_tag_bug_in_avatar(dojo,avatar)
    end   
  end  
  
  def look_for_diff_tag_bug_in_avatar(dojo,avatar)   
    p "   " + avatar.name
    traffic_lights = avatar.increments
    return if traffic_lights.length <= 1
    
    (0..traffic_lights.length-1).each do |tag|
      begin
        look_for_diff_bug_in_traffic_light(dojo,avatar,tag+1)
      rescue Errno::ENOENT => msg
        if !msg.to_s.include? 'Objective C'
          p dojo.name + "," + avatar.name + "," + tag.to_s + ":" + msg
          abort
        end        
      end
    end
  end
  
  def look_for_diff_bug_in_traffic_light(dojo,avatar,tag)
    p "        " + tag.to_s
    params = { :avatar => avatar.name, :tag => tag }
    @kata = avatar.kata
    tag = params[:tag].to_i
    manifest = {}
    @traffic_lights_to_tag = avatar.read_manifest(manifest, tag)
    @all_traffic_lights = avatar.increments    
    @output = manifest[:output]
    diffed_files = git_diff_view(avatar, tag)
    @diffs = git_diff_prepare(diffed_files) 
    @current_filename_id = most_changed_lines_file_id(@diffs)    
  end
   
end
