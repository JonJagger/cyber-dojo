require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/simulated_full_kata_tests.rb

class SimulatedFullKataTests < ActionController::TestCase

  def defunct_count
    # See comments in app/lib/Files.rb
    `ps`.scan(/<defunct>/).length
  end
  
  test "no ruby zombie processes left unkilled" do
    @language = 'Ruby'
    @avatar_count = 8
    @run_tests_count = 10
    run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes
  end
  
  test "no java zombies left unkilled" do
    @language = 'Java JUnit'
    @avatar_count = 3
    @run_tests_count = 4
    run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes('Java JUnit',3,4)
  end
  
  def run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes                                                                         
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
        output = avatar.run_tests(visible_files)
        defunct_after = defunct_count
        assert_equal defunct_before, defunct_after, 'avatar.run_tests(visible_files)' 
        
        info = avatar.name + ', red'
        assert_equal :red, avatar.increments.last[:outcome], info + ', :red,' + output
        print '.'
      end
    end
  end
  
end

