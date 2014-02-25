require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'
require File.dirname(__FILE__) + '/stub_git'
require File.dirname(__FILE__) + '/stub_time_boxed_task'


class AvatarTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    Thread.current[:git] = @git = StubGit.new
    Thread.current[:task] = @task = StubTimeBoxedTask.new
    @dojo = Dojo.new('spied')
    @id = '45ED23A2F1'
    @kata = @dojo[@id]
  end

  def teardown
    Thread.current[:disk] = nil
    Thread.current[:git] = nil
    Thread.current[:task] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false when dir doesn't exist, true when dir does exist" do
    avatar = @dojo[@id]['hippo']
    assert !avatar.exists?
    @disk[avatar.dir].make
    assert avatar.exists?
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    support_filename = 'wibble.dll'
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({
        "support_filenames" => [ support_filename ]
      }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    avatar_write_log = @disk[avatar.dir].write_log
    assert_not_nil avatar_write_log
    assert avatar_write_log.include?(['manifest.rb', visible_files.inspect])
    assert avatar_write_log.include?(['increments.rb', [ ].inspect])
    sandbox = avatar.sandbox
    sandbox_write_log = @disk[sandbox.dir].write_log
    assert_not_nil sandbox_write_log
    assert sandbox_write_log.include?([visible_filename, visible_filename_content]), sandbox_write_log.inspect
    expected_symlink = [
      'symlink',
      language.dir + @disk.dir_separator + support_filename,
      sandbox.dir + @disk.dir_separator + support_filename
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar

    log = @git.log[avatar.dir]
    assert_equal [ 'init', '--quiet'], log[0]
    add1_index = log.index([ 'add', 'increments.rb' ])
    assert add1_index != nil
    add2_index = log.index([ 'add', 'manifest.rb'])
    assert add2_index != nil
    commit1_index = log.index([ 'commit', "-a -m '0' --quiet" ])
    assert commit1_index != nil
    commit2_index = log.index([ 'commit', "-m '0' 0 HEAD" ])
    assert commit2_index != nil

    assert add1_index < commit1_index
    assert add1_index < commit2_index
    assert add2_index < commit1_index
    assert add2_index < commit2_index

    assert_equal [
      [ 'add', 'name']
    ], @git.log[avatar.sandbox.dir]

    assert_equal [ ], @disk[avatar.dir].read_log
    assert_equal [ [ 'manifest.rb', manifest.inspect ] ], @disk[kata.dir].write_log
    assert_equal [ [ 'manifest.rb' ] ], @disk[kata.dir].read_log
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({ }))
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({ }))
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    sandbox_dir = avatar.dir + @disk.dir_separator + 'sandbox'
    visible_files.each do |filename,content|
      assert_equal content, @disk[sandbox_dir].read(filename)
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({ }))
    kata = @dojo.create_kata(manifest)
    avatar = kata.start_avatar
    sandbox = avatar.sandbox
    assert_equal visible_files['cyber-dojo.sh'], @disk[sandbox.dir].read('cyber-dojo.sh')
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
    @disk[@kata.dir].spy_read('manifest.rb', manifest.inspect)
    kata = @dojo.create_kata(manifest)
    @disk[language.dir].spy_read('manifest.json', JSON.unparse({
        "visible_files" => visible_files,
        "unit_test_framework" => "cassert"
      }))
    @disk[language.dir].spy_read('untitled.c', 'content for visible file')
    @disk[language.dir].spy_read('cyber-dojo.sh', 'make')
    avatar = kata.start_avatar
    delta = {
      :changed => [ 'untitled.c' ],
      :unchanged => [ 'cyber-dojo.sh' ],
      :deleted => [ 'wibble.cs' ],
      :new => [ ]
    }
    output = avatar.sandbox.test(delta, avatar.visible_files, timeout=15)
    language = avatar.kata.language
    traffic_light = OutputParser::parse(language.unit_test_framework, output)
    avatar.save_run_tests(visible_files, traffic_light)
    traffic_lights = avatar.traffic_lights
    assert_equal 1, traffic_lights.length
    assert_equal nil, traffic_lights.last[:run_tests_output]
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "diff_lines" do
    avatar = @kata['lion']
    output = avatar.diff_lines(was_tag=3,now_tag=4)
    assert @git.log[avatar.dir].include?(
      [
       'diff',
       '--ignore-space-at-eol --find-copies-harder 3 4 sandbox'
      ])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "locked_read with tag" do
    avatar = @kata['lion']
    output = avatar.visible_files(tag=4)
    assert @git.log[avatar.dir].include?(
      [
       'show',
       '4:manifest.rb'
      ])
  end

end
