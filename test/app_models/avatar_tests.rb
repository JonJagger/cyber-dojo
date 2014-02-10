require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'
require File.dirname(__FILE__) + '/stub_time_boxed_task'


class Avatar2Tests < ActionController::TestCase

  def setup
    Thread.current[:file] = @stub_file = StubDiskFile.new
    Thread.current[:git] = @stub_git = StubDiskGit.new
    Thread.current[:task] = @stub_task = StubTimeBoxedTask.new  
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

  test "avatar creation saves " +
          "visible_files in avatar/manifest.rb, and " +
          "empty avatar/increments.rb, and " +
          "each visible_file into avatar/sandbox, and " +
          "links each support_filename into avatar/sandbox" do
    id = '45ED23A2F1'
    visible_filename = 'visible.txt'
    visible_filename_content = 'content for visible.txt'
    visible_files = {
      visible_filename => visible_filename_content
    }
    language_name = 'C#'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    language = Language.new(root_dir, language_name)
    support_filename = 'wibble.dll' 
    @stub_file.read=({
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => {
        :support_filenames => [ support_filename ]
      }.inspect
    })
    kata = Kata.create(root_dir, manifest)    
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
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name'
    }
    language_name = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    language = Language.new(root_dir, language_name)
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
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
    language_name = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    language = Language.new(root_dir, language_name)
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
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
    language_name = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    language = Language.new(root_dir, language_name)
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
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
    language_name = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }
    language = Language.new(root_dir, language_name)
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
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
    language_name = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    language = Language.new(root_dir, language_name)
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
    }      
    kata = Kata.create(root_dir, manifest)    
    avatar = Avatar.create(kata, 'wolf')    
    sandbox_dir = avatar.dir + @stub_file.separator + 'sandbox' 
    visible_files.each do |filename,content|
      assert_equal content.inspect, @stub_file.read(sandbox_dir, filename)
    end    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after avatar is created sandbox contains cyber-dojo.sh" do
    id = '45ED23A2F1'
    visible_files = {
      'name' => 'content for name',
      'cyber-dojo.sh' => 'make'
    }
    language_name = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    language = Language.new(root_dir, language_name)
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
    }      
    kata = Kata.create(root_dir, manifest)    
    avatar = Avatar.create(kata, 'wolf')
    sandbox = avatar.sandbox    
    assert_equal visible_files['cyber-dojo.sh'].inspect,
      @stub_file.read(sandbox.dir, 'cyber-dojo.sh')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "after first test() traffic_lights contains one traffic-light " +
        "which does not contain output" do    
    id = '45ED23A2F1'
    visible_files = {
      'untitled.c' => 'content for visible file',
      'cyber-dojo.sh' => 'make',
    }
    language_name = 'C'
    manifest = {
      :id => id,
      :visible_files => visible_files,
      :language => language_name
    }
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }      
    kata = Kata.create(root_dir, manifest)    
    language = kata.language
    @stub_file.read = {
      :dir => language.dir,
      :filename => 'manifest.rb',
      :content => {
        :visible_files => visible_files,
        :unit_test_framework => 'cassert'
      }.inspect
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
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'lion')
    output = avatar.diff_lines(was_tag=3,now_tag=4)
    assert @stub_git.log[avatar.dir].include?(
      [
       'diff',
       '--ignore-space-at-eol --find-copies-harder 3 4 sandbox'
      ])  
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "locked_read with tag" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)
    avatar = Avatar.new(kata, 'lion')
    output = avatar.visible_files(tag=4)
    assert @stub_git.log[avatar.dir].include?(
      [
       'show',
       '4:manifest.rb'
      ])  
  end
  
end
