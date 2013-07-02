require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'
require File.dirname(__FILE__) + '/stub_time_boxed_task'


class Avatar2Tests < ActionController::TestCase

  def setup
    @stub_file = StubDiskFile.new
    @stub_git = StubDiskGit.new
    @stub_task = StubTimeBoxedTask.new    
    Thread.current[:file] = @stub_file
    Thread.current[:git] = @stub_git
    Thread.current[:task] = @stub_task
  end

  def teardown
    Thread.current[:file] = nil
    Thread.current[:git] = nil
    Thread.current[:task] = nil
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

  test "after avatar is created sandbox contains cyber-dojo.sh if katas' manifest does" do
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name',
      'cyber-dojo.sh' => 'make'
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
    
    assert_equal visible_files['cyber-dojo.sh'].inspect,
      @stub_file.read(sandbox_dir, 'cyber-dojo.sh')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "after first test-run traffic_lights contains one traffic-light which does not contain output" do
    
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name',
      'cyber-dojo.sh' => 'make',
    }
    language = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    
    kata = Kata.create(root_dir, manifest)    
    avatar = Avatar.create(kata, 'wolf')
    
    language_dir = root_dir + @stub_file.separator + 'languages' + @stub_file.separator + language
    @stub_file.read = {
      :dir => language_dir,
      :filename => 'manifest.rb',
      :content => {
        :visible_files => visible_files,
        :unit_test_framework => 'cassert'
      }.inspect
    }
    @stub_file.read = {
      :dir => language_dir,
      :filename => 'name',
      :content => 'content for name'
    }
    @stub_file.read = {
      :dir => language_dir,
      :filename => 'cyber-dojo.sh',
      :content => 'make'
    }    
    
    output = avatar.sandbox.run_tests(avatar.visible_files, timeout=15)
    language = avatar.kata.language
    traffic_light = CodeOutputParser::parse(language.unit_test_framework, output)
    avatar.save_run_tests(visible_files, traffic_light)
    
    traffic_lights = avatar.traffic_lights
    assert_equal 1, traffic_lights.length
    assert_equal nil, traffic_lights.last[:run_tests_output]
  end
  
end
