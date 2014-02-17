require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'
require File.dirname(__FILE__) + '/stub_time_boxed_task'


class AvatarTests < ActionController::TestCase

  def setup
    Thread.current[:file] = @stub_file = StubDiskFile.new
    Thread.current[:git] = @stub_git = StubDiskGit.new
    Thread.current[:task] = @stub_task = StubTimeBoxedTask.new
    root_dir = '/where'
    @dojo = Dojo.new(root_dir)
    @id = '45ED23A2F1'
  end

  def teardown
    Thread.current[:file] = nil
    Thread.current[:git] = nil
    Thread.current[:task] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false when its folder doesn't exist" do
    avatar = Avatar.new(@dojo[@id], 'hippo')
    assert_equal false, avatar.exists?
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "exists? is true when its folder does exist" do
    avatar = Avatar.new(@dojo[@id], 'hippo')
    @stub_file.read = {
      :dir => avatar.dir,
      :filename => '',
      :content => ''
    }    
    assert_equal true, avatar.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar creation saves " +
          "visible_files in avatar/manifest.rb, and " +
          "empty avatar/increments.rb, and " +
          "each visible_file into avatar/sandbox, and " +
          "links each support_filename into avatar/sandbox" do
    visible_filename = 'visible.txt'
    visible_filename_content = 'content for visible.txt'
    visible_files = {
      visible_filename => visible_filename_content
    }
    language = @dojo.language('C#')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    support_filename = 'wibble.dll' 
    @stub_file.read=({
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({
        "support_filenames" => [ support_filename ]
      })
    })
    kata = @dojo.create_kata(manifest)    
    avatar = Avatar.create(kata, 'wolf')            
    assert_not_nil @stub_file.write_log[avatar.dir]
    assert @stub_file.write_log[avatar.dir].include?(['manifest.rb', visible_files.inspect])
    assert @stub_file.write_log[avatar.dir].include?(['increments.rb', [ ].inspect])    
    sandbox = avatar.sandbox
    log = @stub_file.write_log[sandbox.dir]
    assert_not_nil log
    assert log.include?([visible_filename, visible_filename_content.inspect]), log.inspect    
    expected_symlink = [
      'symlink',
      language.dir + @stub_file.separator + support_filename,
      sandbox.dir + @stub_file.separator + support_filename
    ]
    assert @stub_file.symlink_log.include?(expected_symlink), @stub_file.symlink_log.inspect    
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "avatar creation sets up initial git repo of visible files " +
        "but not support_files" do  
    visible_files = {
      'name' => 'content for name'
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({ })
    }      
    kata = @dojo.create_kata(manifest)    
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
    visible_files = {
      'name' => 'content for name'
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({ })
    }    
    kata = @dojo.create_kata(manifest)
    avatar = Avatar.create(kata, 'wolf')    
    assert_equal [ ], avatar.traffic_lights    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar returns kata it was created with" do
    visible_files = {
      'name' => 'content for name'
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({ })
    }      
    kata = @dojo.create_kata(manifest)
    avatar = Avatar.create(kata, 'wolf')    
    assert_equal kata, avatar.kata    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar's tag 0 repo contains an empty output file only if kata-manifest does" do    
    visible_files = {
      'name' => 'content for name',
      'output' => ''
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({ })
    }    
    kata = @dojo.create_kata(manifest)
    avatar = Avatar.create(kata, 'wolf')    
    visible_files = avatar.visible_files
    assert visible_files.keys.include?('output'),
          "visible_files.keys.include?('output')"
    assert_equal "", visible_files['output']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after avatar is created sandbox contains visible_files" do
    visible_files = {
      'name' => 'content for name',
      'output' => ''
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({ })
    }      
    kata = @dojo.create_kata(manifest)    
    avatar = Avatar.create(kata, 'wolf')    
    sandbox_dir = avatar.dir + @stub_file.separator + 'sandbox' 
    visible_files.each do |filename,content|
      assert_equal content.inspect, @stub_file.read(sandbox_dir, filename)
    end    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after avatar is created sandbox contains cyber-dojo.sh" do
    visible_files = {
      'name' => 'content for name',
      'cyber-dojo.sh' => 'make'
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({ })
    }      
    kata = @dojo.create_kata(manifest)    
    avatar = Avatar.create(kata, 'wolf')
    sandbox = avatar.sandbox    
    assert_equal visible_files['cyber-dojo.sh'].inspect,
      @stub_file.read(sandbox.dir, 'cyber-dojo.sh')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "after first test() traffic_lights contains one traffic-light " +
        "which does not contain output" do    
    visible_files = {
      'untitled.c' => 'content for visible file',
      'cyber-dojo.sh' => 'make',
    }
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @stub_file.read = {
      :dir => @dojo[@id].dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }      
    kata = @dojo.create_kata(manifest)    
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.json',
      :content => JSON.unparse({
        "visible_files" => visible_files,
        "unit_test_framework" => "cassert"
      })
    }
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'untitled.c',
      :content => 'content for visible file'
    }
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'cyber-dojo.sh',
      :content => 'make'
    }    
    avatar = Avatar.create(kata, 'wolf')    
    delta = {
      :changed => [ 'untitled.c' ],
      :unchanged => [ 'cyber-dojo.sh' ],
      :deleted => [ 'wibble.cs' ],
      :new => [ ]      
    }
    output = avatar.sandbox.test(delta, avatar.visible_files, timeout=15)    
    language = avatar.kata.language
    traffic_light = CodeOutputParser::parse(language.unit_test_framework, output)    
    avatar.save_run_tests(visible_files, traffic_light)    
    traffic_lights = avatar.traffic_lights
    assert_equal 1, traffic_lights.length
    assert_equal nil, traffic_lights.last[:run_tests_output]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "diff_lines" do
    avatar = Avatar.new(@dojo[@id], 'lion')
    output = avatar.diff_lines(was_tag=3,now_tag=4)
    assert @stub_git.log[avatar.dir].include?(
      [
       'diff',
       '--ignore-space-at-eol --find-copies-harder 3 4 sandbox'
      ])  
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "locked_read with tag" do
    avatar = Avatar.new(@dojo[@id], 'lion')
    output = avatar.visible_files(tag=4)
    assert @stub_git.log[avatar.dir].include?(
      [
       'show',
       '4:manifest.rb'
      ])  
  end

end
