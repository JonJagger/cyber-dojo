require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'

class Avatar2Tests < ActionController::TestCase

  def setup
    @stub_file = StubDiskFile.new
    @stub_git = StubDiskGit.new
    Thread.current[:file] = @stub_file
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

  test "avatar creation saves visible_files in manifest.rb and empty increments.rb both in avatar dir" do  
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name'
    }
    manifest = {
      :id => id,
      :visible_files => visible_files
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    
    kata = Kata.create(root_dir, manifest)    
    avatar = Avatar.create(kata, 'wolf')    
    
    assert_equal [
        [ 'manifest.rb', visible_files.inspect ],
        [ 'increments.rb', [ ].inspect ]
      ],
      @stub_file.write_log[avatar.dir]
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "avatar creation sets up initial git repo of visible files" do  
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name'
    }
    manifest = {
      :id => id,
      :visible_files => visible_files
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    
    kata = Kata.create(root_dir, manifest)    
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
    
    assert_equal [ [ 'manifest.rb', manifest.inspect ] ], @stub_file.write_log[kata.dir]         
    assert_equal [ [ 'manifest.rb' ] ], @stub_file.read_log[kata.dir]
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar names all begin with a different letter" do
    assert_equal Avatar.names.collect{|name| name[0]}.uniq.length, Avatar.names.length
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "avatar has no traffic-lights before first test-run" do
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name'
    }
    manifest = {
      :id => id,
      :visible_files => visible_files
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    
    kata = Kata.create(root_dir, manifest)
    avatar = Avatar.create(kata, 'wolf')
    
    assert_equal [ ], avatar.traffic_lights    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar returns kata it was created with" do
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name'
    }
    manifest = {
      :id => id,
      :visible_files => visible_files
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    
    kata = Kata.create(root_dir, manifest)
    avatar = Avatar.create(kata, 'wolf')
    
    assert_equal kata, avatar.kata    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar's tag 0 repo contains an empty output file only if kata-manifest does" do    
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name',
      'output' => ''
    }
    manifest = {
      :id => id,
      :visible_files => visible_files
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    
    kata = Kata.create(root_dir, manifest)
    avatar = Avatar.create(kata, 'wolf')
    
    visible_files = avatar.visible_files
    assert visible_files.keys.include?('output'),
          "visible_files.keys.include?('output')"
    assert_equal "", visible_files['output']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "after avatar is created sandbox contains visible_files" do
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name',
      'output' => ''
    }
    manifest = {
      :id => id,
      :visible_files => visible_files
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    
    kata = Kata.create(root_dir, manifest)    
    avatar = Avatar.create(kata, 'wolf')
    
    sandbox_dir = avatar.dir + @stub_file.separator + 'sandbox' 
    visible_files.each do |filename,content|
      assert_equal content.inspect, @stub_file.read(sandbox_dir, filename)
    end    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
end
