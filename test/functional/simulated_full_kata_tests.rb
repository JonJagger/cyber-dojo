require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/simulated_full_kata_tests.rb

class SimulatedFullKataTests < ActionController::TestCase

  ROOT_TEST_DIR = RAILS_ROOT + '/test/katas'

  def root_test_dir_reset
    system("rm -rf #{ROOT_TEST_DIR}")
    Dir.mkdir ROOT_TEST_DIR
  end

  def make_params(language)
    params = {
      :katas_root_dir => ROOT_TEST_DIR,
      :filesets_root_dir => RAILS_ROOT +  '/filesets',
      :browser => 'Firefox',
      'language' => language,
      'exercise' => 'Yahtzee',
      'name' => 'Valentine'
    }
  end

  def make_kata(language)
    params = make_params(language)
    fileset = InitialFileSet.new(params)
    info = Kata::create_new(fileset)
    params[:id] = info[:id]
    Kata.new(params)    
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
    kata = make_kata(language)

    visible_files_set = { }
    avatars = [ ]
    
    avatar_count.times do |n|
      avatar = Avatar.new(kata, Avatar.names[n])
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

