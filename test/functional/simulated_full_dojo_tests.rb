require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/simulated_full_dojo_tests.rb

class SimulatedFullDojoTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def params?(language)
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Root_test_folder,
      :filesets_root => RAILS_ROOT + '/filesets',
      'kata' => 'Unsplice',
      'language' => language,
      :browser => 'None (test)'
    }
  end
  
  def create_dojo(language)
    root_test_folder_reset    
    assert Dojo::create(params?(language))
    Dojo.configure(params?(language))
    Dojo.new(params?(language))
  end
  
  def defunct_count
    # See comments in app/lib/Files.rb
    `ps`.scan(/<defunct>/).length
  end
  
  def test_no_ruby_zombie_processes_left_unkilled
    run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes('Ruby')
  end
  
  def test_no_java_zombies_left_unkilled
    run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes('Java',3,4)
  end
  
  def run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes(language, avatar_count=8, run_tests_count=10)
    dojo = create_dojo(language)

    visible_files_set = { }
    avatars = [ ]
    
    avatar_count.times do |n|
      avatar = Avatar.new(dojo, Avatar.names[n])
      visible_files_set[avatar.name] = avatar.visible_files
      avatars << avatar
    end

    run_tests_count.times do |n|
      avatars.each do |avatar|
        visible_files = visible_files_set[avatar.name]
        
        defunct_before = defunct_count
        output = avatar.run_tests(visible_files)
        defunct_after = defunct_count
        assert_equal defunct_before, defunct_after, 'avatar.run_tests(visible_files)' 
        
        info = avatar.name + ', red'
        assert_equal :failed, avatar.increments.last[:outcome], info + ', red,' + output
        print '.'
      end
    end
  end
  
end

