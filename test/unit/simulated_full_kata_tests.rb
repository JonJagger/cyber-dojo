require File.dirname(__FILE__) + '/../test_helper'

class SimulatedFullKataTests < ActionController::TestCase

  def defunct_count
    # See comments in app/lib/Files.rb
    `ps`.scan(/<defunct>/).length
  end
  
  # These tests feel like they should be in test/lib/popen_read_tests.rb
  test "no ruby zombie processes left unkilled" do
    @language = 'Ruby-installed-and-working'
    @avatar_count = 6
    @run_tests_count = 8
    check_running_tests_does_not_accumulate_zombie_defunct_shell_processes
  end
  
  test "no c zombies left unkilled" do
    @language = 'C assert'
    @avatar_count = 3
    @run_tests_count = 4
    check_running_tests_does_not_accumulate_zombie_defunct_shell_processes
  end
  
  def check_running_tests_does_not_accumulate_zombie_defunct_shell_processes
    kata = make_kata(@language)

    visible_files_set = { }
    avatars = [ ]
    
    @avatar_count.times do |n|
      avatar = Avatar.new(kata, Avatar.names[n])
      visible_files_set[avatar.name] = avatar.visible_files
      avatars << avatar
    end

    @run_tests_count.times do |n|
      avatars.each do |avatar|
        visible_files = visible_files_set[avatar.name]
        
        defunct_before = defunct_count
        output = run_tests(avatar, visible_files)        
        defunct_after = defunct_count
        
        assert_equal defunct_before, defunct_after, 'run_tests(avatar, visible_files)' 
        
        info = avatar.name + ', red'
        assert_equal :red, avatar.increments.last[:outcome], info + ', :red,' + output
        print 's'
      end
    end
  end
  
end

