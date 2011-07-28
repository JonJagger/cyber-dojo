require File.dirname(__FILE__) + '/../test_helper'

# > cd cyberdojo/test
# > ruby functional/simulated_full_dojo_tests.rb

class SimulatedFullDojoTests < ActionController::TestCase

  Root_test_folder = 'test_dojos'

  def root_test_folder_reset
    system("rm -rf #{Root_test_folder}")
    Dir.mkdir Root_test_folder
  end

  def make_params
    { :dojo_name => 'Jon Jagger', 
      :dojo_root => Dir.getwd + '/' + Root_test_folder,
      :filesets_root => Dir.getwd + '/../filesets'
    }
  end
  
  def defunct_count
    # See comments in app/helpers/popen_read.rb
    `ps`.scan(/<defunct>/).length
  end
  
  def test_run_tests_submissions_do_not_accumulate_zombie_defunct_shell_processes
    ps_defunct_count_1 = defunct_count
    
    root_test_folder_reset    
    ps_defunct_count_2 = defunct_count
    
    assert_equal ps_defunct_count_1, ps_defunct_count_2, 'root_test_folder_reset'
    
    params = make_params
    ps_defunct_count_3 = defunct_count
    
    assert_equal ps_defunct_count_2, ps_defunct_count_3, 'make_params'
    
    assert Dojo::create(params)
    ps_defunct_count_4 = defunct_count 
    
    assert_equal ps_defunct_count_3, ps_defunct_count_4, 'Dojo::create(params)'
    
    dojo = Dojo.new(params)
    ps_defunct_count_5 = defunct_count 

    assert_equal ps_defunct_count_4, ps_defunct_count_5, 'Dojo.new(params)'

    language = 'C'    
    manifests = {}
    avatars = []
    8.times do |n|
      defunct_before = defunct_count
      avatar = dojo.create_avatar({ 'language' => language })
      defunct_after = defunct_count
      assert_equal defunct_before, defunct_after, 'dojo.create_avatar(...)' 
      
      manifest = {}
      
      defunct_before = defunct_count
      avatar.read_manifest(manifest)
      defunct_after = defunct_count
      assert_equal defunct_before, defunct_after, 'avatar.read_manifest(manifest)' 
      
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
        
        info = avatar.name + ', ' + language + ', red'
        assert_equal :failed, increments.last[:outcome], info + ', red,' + manifest[:output]
        print '.'
      end
    end
  end
  
end

