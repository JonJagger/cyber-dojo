require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'

class Avatar2Tests < ActionController::TestCase

  def setup
    @stub_file = StubDiskFile.new
    Thread.current[:file] = @stub_file
    @stub_git = StubDiskGit.new
    Thread.current[:git] = @stub_git
  end

  def teardown
    Thread.current[:file] = nil
    Thread.current[:git] = nil
  end

  def root_dir
    (Rails.root + 'test/cyberdojo').to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "avatar creation saves manifest.rb and empty increments.rb in avatar dir" do  
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)    
    avatar = Avatar.create(kata, 'wolf')    
    
    assert_equal [
        [ 'manifest.rb', { "name" => "content for name" }.inspect ],
        [ 'increments.rb', [ ].inspect ]
      ],
      @stub_file.write_log[avatar.dir]
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "avatar creation sets up initial git repo of visible files" do  
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)    
    avatar = Avatar.create(kata, 'wolf')    
    
    assert_equal [
          [ 'init', '--quiet'],
          [ 'add', 'increments.rb' ],
          [ 'add', 'manifest.rb'],
          [ 'add', 'sandbox/name'],
          [ 'commit', "-a -m '0' --quiet" ],
          [ 'commit', "-m '0' 0 HEAD" ]
        ], 
      @stub_git.log[avatar.dir]
      
    assert_equal nil, @stub_file.read_log[avatar.dir]
    
    assert_equal [ [ 'manifest.rb', info.inspect ] ], @stub_file.write_log[kata.dir]         
    assert_equal [ [ 'manifest.rb' ] ], @stub_file.read_log[kata.dir]
  end
    
  
end
