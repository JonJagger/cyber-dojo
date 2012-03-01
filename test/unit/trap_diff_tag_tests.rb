require File.dirname(__FILE__) + '/../test_helper'
require 'recent_helper'
require 'GitDiffParser'

# > ruby test/unit/trap_diff_tag_tests.rb

class TrapDiffTagTests < ActionController::TestCase

  # The diff-view code initially shipped without
  # code to handle renamed files or deleted files.
  # It also seemed to have a bug that cropped up
  # on increment zero.
  # I used these these tests to make sure the modified
  # diff-code worked for all avatars for all dojos
  # on my hard disk.
  # I added specific tests in git_diff_parser_tests.rb
  # so the tests are commented out as they take quite
  # a while to run over numerous dojos
  
  include RecentHelper
  include GitDiff

  def params
    { 
      :dojo_name => 'diff-ok', 
      :dojo_root => RAILS_ROOT + '/dojos',
      :filesets_root => RAILS_ROOT + '/filesets'
    }      
  end
  
  # For when regression test below finds a failure
  def X_test_look_for_diff_tag_bug_in_specific_increment
    dojo = Dojo.new(params)
    avatar = Avatar.new(dojo, 'raccoon')
    look_for_diff_bug_in_traffic_light(dojo,avatar,3)   
  end

  # Regression test. Takes a long time. Default is X_ prefix so it won't run.
  def X_test_look_for_diff_tag_bugs_in_all_dojos_on_hard_disk
    index_filename = params[:dojo_root] + '/index.rb'
    index = eval IO.popen("cat #{index_filename}").read
    index.each {|e| look_for_diff_tag_bug_in_dojo(e[:name]) }
  end
  
  def look_for_diff_tag_bug_in_dojo(name)
    p name    
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
        # I removed Objective C filesets from my hard disk
        # (Compiler needs some tweaking after OS upgrade)
        if !msg.to_s.include? 'Objective C'
          p dojo.name + "," + avatar.name + "," + tag.to_s + ":" + msg
          abort
        end        
      end
    end
  end
  
  def look_for_diff_bug_in_traffic_light(dojo,avatar,tag)
    p "        " + tag.to_s
    @traffic_lights_to_tag = avatar.increments(tag)
    @all_traffic_lights = avatar.increments    
    diffed_files = git_diff_view(avatar, tag)
    @diffs = git_diff_prepare(diffed_files) 
    @current_filename_id = most_changed_lines_file_id(@diffs)    
  end
   
end
