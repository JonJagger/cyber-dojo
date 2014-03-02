require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'
require File.dirname(__FILE__) + '/stub_git'
require File.dirname(__FILE__) + '/stub_runner'


class AvatarTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    Thread.current[:git] = @git = StubGit.new
    Thread.current[:runner] = @runner = StubRunner.new
    @dojo = Dojo.new('spied/')
    @id = '45ED23A2F1'
    @kata = @dojo[@id]
  end

  def teardown
    @disk.teardown
    Thread.current[:disk] = nil
    Thread.current[:git] = nil
    Thread.current[:runner] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no disk on thread the ctor raises" do
    Thread.current[:disk] = nil
    error = assert_raises(RuntimeError) { Avatar.new(nil,nil) }
    assert_equal 'no disk', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no git on thread the ctor raises" do
    Thread.current[:git] = nil
    error = assert_raises(RuntimeError) { Avatar.new(nil,nil) }
    assert_equal 'no git', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false when dir doesn't exist, true when dir does exist" do
    exists_is_false_when_dir_doesnt_exist_true_when_dir_does_exist('rb')
    teardown
    setup
    exists_is_false_when_dir_doesnt_exist_true_when_dir_does_exist('json')
  end

  def exists_is_false_when_dir_doesnt_exist_true_when_dir_does_exist(format)
    dojo = Dojo.new('spied', format)
    kata = dojo[@id]
    avatar = kata['hippo']
    assert !avatar.exists?
    avatar.dir.make
    assert avatar.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "in rb format avatar creation saves " +
          "visible_files in avatar/manifest.rb, and " +
          "empty avatar/increments.rb, and " +
          "each visible_file into avatar/sandbox, and " +
          "links each support_filename into avatar/sandbox" do
    visible_filename = 'visible.txt'
    visible_filename_content = 'content for visible.txt'
    visible_files = {
      visible_filename => visible_filename_content
    }
    @dojo = Dojo.new('spied/','rb')
    language = @dojo.language('C#')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @kata = @dojo[@id]
    kata_manifest_spy_read('rb',manifest)
    support_filename = 'wibble.dll'
    language.dir.spy_read('manifest.json', JSON.unparse({
        'support_filenames' => [ support_filename ]
      }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    assert_not_nil avatar
    assert_not_nil avatar.dir
    assert_not_nil avatar.dir.log
    assert avatar.dir.log.include?(['write','manifest.rb', visible_files.inspect])
    assert avatar.dir.log.include?(['write','increments.rb', [ ].inspect])
    sandbox = avatar.sandbox
    assert_not_nil sandbox
    assert_not_nil sandbox.dir
    assert_not_nil sandbox.dir.log
    assert sandbox.dir.log.include?(['write',visible_filename, visible_filename_content]), sandbox.dir.log.inspect
    expected_symlink = [
      'symlink',
      language.path + support_filename,
      sandbox.path + support_filename
    ]
    assert @disk.symlink_log.include?(expected_symlink), @disk.symlink_log.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - -

  test "in json format avatar creation saves " +
          "visible_files in avatar/manifest.json, and " +
          "empty avatar/increments.json, and " +
          "each visible_file into avatar/sandbox, and " +
          "links each support_filename into avatar/sandbox" do
    visible_filename = 'visible.txt'
    visible_filename_content = 'content for visible.txt'
    visible_files = {
      visible_filename => visible_filename_content
    }
    @dojo = Dojo.new('spied/','json')
    language = @dojo.language('C#')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    kata_manifest_spy_read('json',manifest)
    support_filename = 'wibble.dll'
    language.dir.spy_read('manifest.json', JSON.unparse({
        'support_filenames' => [ support_filename ]
      }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    assert_not_nil avatar
    assert_not_nil avatar.dir
    assert_not_nil avatar.dir.log
    assert avatar.dir.log.include?(['write','manifest.json', JSON.unparse(visible_files)])
    assert avatar.dir.log.include?(['write','increments.json', JSON.unparse([ ])])
    sandbox = avatar.sandbox
    assert_not_nil sandbox
    assert_not_nil sandbox.dir
    assert_not_nil sandbox.dir.log
    assert sandbox.dir.log.include?(['write',visible_filename, visible_filename_content]), sandbox.dir.log.inspect
    expected_symlink = [
      'symlink',
      language.path + support_filename,
      sandbox.path + support_filename
    ]
    assert @disk.symlink_log.include?(expected_symlink), @disk.symlink_log.inspect
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
    kata_manifest_spy_read('rb',manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar

    git_log = @git.log[avatar.path]
    assert_equal [ 'init', '--quiet'], git_log[0]
    add1_index = git_log.index([ 'add', 'increments.rb' ])
    assert add1_index != nil
    add2_index = git_log.index([ 'add', 'manifest.rb'])
    assert add2_index != nil
    commit1_index = git_log.index([ 'commit', "-a -m '0' --quiet" ])
    assert commit1_index != nil
    commit2_index = git_log.index([ 'commit', "-m '0' 0 HEAD" ])
    assert commit2_index != nil

    assert add1_index < commit1_index
    assert add1_index < commit2_index
    assert add2_index < commit1_index
    assert add2_index < commit2_index

    assert_equal [
      [ 'add', 'name']
    ], @git.log[avatar.sandbox.path], @git.log.inspect

    assert avatar.dir.log.include?([ 'write', 'manifest.rb', visible_files.inspect ]), avatar.dir.log.inspect
    assert avatar.dir.log.include?([ 'write', 'increments.rb', [ ].inspect ]), avatar.dir.log.inspect
    assert kata.dir.log.include?([ 'write','manifest.rb', manifest.inspect ]), kata.dir.log.inspect
    assert kata.dir.log.include?([ 'read','manifest.rb',manifest.inspect ]), kata.dir.log.inspect
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
    kata_manifest_spy_read('rb',manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
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
    kata_manifest_spy_read('rb',manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
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
    kata_manifest_spy_read('rb',manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    visible_files = avatar.visible_files
    assert visible_files.keys.include?('output'),
          "visible_files.keys.include?('output')"
    assert_equal "", visible_files['output']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after avatar is created sandbox contains separate visible_files" do
    after_avatar_is_created_sandbox_contains_separate_visible_files('rb')
    after_avatar_is_created_sandbox_contains_separate_visible_files('json')
  end

  def after_avatar_is_created_sandbox_contains_separate_visible_files(format)
    @dojo = Dojo.new('spied/',format)
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
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    visible_files.each do |filename,content|
      assert_equal content, avatar.sandbox.dir.read(filename)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after avatar is created avatar dir contains all visible_files in manifest" do
    after_avatar_is_created_avatar_dir_contains_manifest_holding_all_visible_files('rb')
    after_avatar_is_created_avatar_dir_contains_manifest_holding_all_visible_files('json')
  end

  def after_avatar_is_created_avatar_dir_contains_manifest_holding_all_visible_files(format)
    @dojo = Dojo.new('spied/',format)
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
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    avatar.visible_files.each do |filename,content|
      assert visible_files.keys.include?(filename)
      assert_equal visible_files[filename], content
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
    kata_manifest_spy_read('rb',manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    sandbox = avatar.sandbox
    assert_equal visible_files['cyber-dojo.sh'], sandbox.dir.read('cyber-dojo.sh')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after first test() traffic_lights contains one traffic-light " +
        "which does not contain output" do
    after_first_test_traffic_lights_contains_one_traffic_light('rb')
    after_first_test_traffic_lights_contains_one_traffic_light('rb')
  end

  def after_first_test_traffic_lights_contains_one_traffic_light(format)
    visible_files = {
      'untitled.c' => 'content for visible file',
      'cyber-dojo.sh' => 'make',
    }
    @dojo = Dojo.new('spied/', format)
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :visible_files => visible_files,
      :language => language.name
    }
    @kata = @dojo[@id]
    kata_manifest_spy_read(format,manifest)
    kata = @dojo.create_kata(manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({
        "visible_files" => visible_files,
        "unit_test_framework" => "cassert"
      }))
    avatar = @kata.start_avatar
    avatar.sandbox.dir.spy_write('untitled.c', 'content for visible file')
    avatar.sandbox.dir.spy_write('cyber-dojo.sh', 'make')
    delta = {
      :changed => [ 'untitled.c' ],
      :unchanged => [ 'cyber-dojo.sh' ],
      :deleted => [ 'wibble.cs' ],
      :new => [ ]
    }
    avatar.sandbox.write(delta, avatar.visible_files)
    output = avatar.sandbox.test(timeout=15)
    visible_files['output'] = output
    avatar.save_visible_files(visible_files)

    traffic_light = OutputParser::parse(@kata.language.unit_test_framework, output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    assert_equal 1, traffic_lights.length
    assert_equal nil, traffic_lights.last[:run_tests_output]
    assert_equal nil, traffic_lights.last[:output]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "one more traffic light each test() call" do
    one_more_traffic_light_each_test('rb')
    teardown
    setup
    one_more_traffic_light_each_test('json')
  end

  def one_more_traffic_light_each_test(format)
    @dojo = Dojo.new('spied/', format)
    @kata = @dojo[@id]
    language = @dojo.language('C')
    manifest = {
      :id => @id,
      :language => language.name,
      :visible_files => [ ]
    }
    kata_manifest_spy_read(format,manifest)
    @kata = @dojo.create_kata(manifest)
    language.dir.spy_read('manifest.json', JSON.unparse({
        "visible_files" => [ ],
        "unit_test_framework" => "cassert"
      }))
    avatar = @kata.start_avatar
    output = 'stubbed'
    traffic_light = OutputParser::parse('cassert', output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    assert_equal 1, traffic_lights.length
    traffic_light = OutputParser::parse('cassert', output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    assert_equal 2, traffic_lights.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "diff_lines" do
    avatar = @kata['lion']
    output = avatar.diff_lines(was_tag=3,now_tag=4)
    assert @git.log[avatar.path].include?(
      [
       'diff',
       '--ignore-space-at-eol --find-copies-harder 3 4 sandbox'
      ])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "locked_read with tag" do
    avatar = @kata['lion']
    output = avatar.visible_files(tag=4)
    assert @git.log[avatar.path].include?(
      [
       'show',
       '4:manifest.rb'
      ])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def kata_manifest_spy_read(format, spied)
    if format == 'rb'
      @kata.dir.spy_read('manifest.rb', spied.inspect)
    end
    if format == 'json'
      @kata.dir.spy_read('manifest.json', JSON.unparse(spied))
    end
  end

end
