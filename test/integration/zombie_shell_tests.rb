require File.dirname(__FILE__) + '/../test_helper'

class ZombieShellTests < ActionController::TestCase

  def defunct_count
    # See comments in app/lib/TimeBoxedTask.rb
    `ps`.scan(/<defunct>/).length
  end
  
  test "check running tests does not accumulate zombie defunct shell processes" do
    language = 'Ruby-installed-and-working'
    avatar_count = 4
    run_tests_count = 4

    kata = make_kata(language)

    visible_files_set = { }
    avatars = [ ]
    
    avatar_count.times do |n|
      avatar = Avatar.create(kata, Avatar.names[n])
      visible_files_set[avatar.name] = avatar.visible_files
      avatars << avatar
    end

    run_tests_count.times do |n|
      avatars.each do |avatar|
        visible_files = visible_files_set[avatar.name]        
        defunct_before = defunct_count
        delta = {
          :changed => visible_files.keys,
          :unchanged => [ ],
          :deleted => [ ],
          :new => [ ]      
        }            
        output = run_test(delta, avatar, visible_files, timeout=5)        
        defunct_after = defunct_count
        
        assert_equal defunct_before, defunct_after, 'run_test(delta, avatar, visible_files)' 
        
        info = avatar.name + ', red'
        assert_equal :red, avatar.traffic_lights.last[:colour], info + ', :red,' + output
        print 's'
      end
    end
  end
  
end

