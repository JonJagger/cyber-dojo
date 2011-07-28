require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/simulated_full_dojo_tests.rb

class SimulatedFullDojoTests < ActionController::TestCase

  Root_test_folder = RAILS_ROOT + '/test/test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Root_test_folder,
      :filesets_root => RAILS_ROOT + '/filesets',
      'kata' => 'Unsplice (*)',
      'language' => 'C'
    }
  end
  
  def defunct_count
    # See comments in app/helpers/popen_read.rb
    `ps`.scan(/<defunct>/).length
  end
  
  def test_run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes
    root_test_folder_reset    
    params = make_params
    assert Dojo::create(params)
    Dojo.configure(params)
    dojo = Dojo.new(params)

    manifests = {}
    avatars = []
    
    8.times do |n|
      avatar = dojo.create_avatar()
      manifest = {}
      avatar.read_manifest(manifest)
      manifests[avatar.name] = manifest
      avatars << avatar
    end

    10.times do |n|
      avatars.each do |avatar|
        manifest = manifests[avatar.name]
        
        defunct_before = defunct_count
        increments = avatar.run_tests(manifest)
        defunct_after = defunct_count
        assert_equal defunct_before, defunct_after, 'avatar.run_tests(manifest)' 
        
        info = avatar.name + ', red'
        assert_equal :failed, increments.last[:outcome], info + ', red,' + manifest[:output]
        print '.'
      end
    end
  end
  
end

