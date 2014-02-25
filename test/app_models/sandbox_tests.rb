require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'
require File.dirname(__FILE__) + '/stub_git'
require File.dirname(__FILE__) + '/stub_time_boxed_task'


class SandboxTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    Thread.current[:git] = @git = StubGit.new
    Thread.current[:task] = @stub_task = StubTimeBoxedTask.new
    @dojo = Dojo.new('stubbed')
    @id = '45ED23A2F1'
    @kata = @dojo[@id]
    @avatar = @kata['hippo']
    @sandbox = @avatar.sandbox
  end

  def teardown
    Thread.current[:disk] = nil
    Thread.current[:git] = nil
    Thread.current[:task] = nil
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not end in slash" do
    assert !@sandbox.dir.end_with?(@disk.dir_separator)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not have doubled separator" do
    doubled_separator = @disk.dir_separator * 2
    assert_equal 0, @sandbox.dir.scan(doubled_separator).length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir is not created until file is saved" do
    assert !@disk[@sandbox.dir].exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after run_tests() a file called output is saved in sandbox " +
         "and an output file is not inserted into the visible_files argument" do
    visible_files = {
      'untitled.c' => 'content for code file',
      'untitled.test.c' => 'content for test file',
      'cyber-dojo.sh' => 'make'
    }
    assert !visible_files.keys.include?('output')
    delta = {
      :changed => [ 'untitled.c' ],
      :unchanged => [ 'untitled.test.c' ],
      :deleted => [ ],
      :new => [ ]
    }
    output = @sandbox.test(delta, visible_files)
    assert !visible_files.keys.include?('output')
    assert output.class == String, "output.class == String"
    assert_equal "amber", output
    assert_equal ['output',"amber"], @disk[@sandbox.dir].write_log.last
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "test():delta[:changed] files are saved" do
    visible_files = {
      'untitled.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ 'untitled.cs', 'untitled.test.cs'  ],
      :unchanged => [ ],
      :deleted => [ ],
      :new => [ ]
    }
    @sandbox.test(delta, visible_files)
    log = @disk[@sandbox.dir].write_log
    saved_files = filenames_in(log)
    assert_equal ['output', 'untitled.cs', 'untitled.test.cs'], saved_files.sort
    assert log.include?(['untitled.cs', 'content for code file' ]), log.inspect
    assert log.include?(['untitled.test.cs', 'content for test file' ]), log.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "test():delta[:unchanged] files are not saved" do
    visible_files = {
      'untitled.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ 'untitled.cs' ],
      :unchanged => [ 'cyber-dojo.sh', 'untitled.test.cs' ],
      :deleted => [ ],
      :new => [ ]
    }
    @sandbox.test(delta, visible_files)
    log = @disk[@sandbox.dir].write_log
    saved_files = filenames_in(log)
    assert !saved_files.include?('cyber-dojo.sh'), saved_files.inspect
    assert !saved_files.include?('untitled.test.cs'), saved_files.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "test():delta[:new] files are saved and git added" do
    visible_files = {
      'wibble.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ ],
      :unchanged => [ 'cyber-dojo.sh', 'untitled.test.cs' ],
      :deleted => [ ],
      :new => [ 'wibble.cs' ]
    }
    @sandbox.test(delta, visible_files)
    write_log = @disk[@sandbox.dir].write_log
    saved_files = filenames_in(write_log)
    assert saved_files.include?('wibble.cs'), saved_files.inspect

    git_log = @git.log[@sandbox.dir]
    assert git_log.include?([ 'add', 'wibble.cs' ]), git_log.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "test():delta[:deleted] files are git rm'd" do
    visible_files = {
      'untitled.cs' => 'content for code file',
      'untitled.test.cs' => 'content for test file',
      'cyber-dojo.sh' => 'gmcs'
    }
    delta = {
      :changed => [ 'untitled.cs' ],
      :unchanged => [ 'cyber-dojo.sh', 'untitled.test.cs' ],
      :deleted => [ 'wibble.cs' ],
      :new => [ ]
    }
    @sandbox.test(delta, visible_files)
    write_log = @disk[@sandbox.dir].write_log
    saved_files = filenames_in(write_log)
    assert !saved_files.include?('wibble.cs'), saved_files.inspect

    git_log = @git.log[@sandbox.dir]
    assert git_log.include?([ 'rm', 'wibble.cs' ]), git_log.inspect
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def filenames_in(log)
    log.collect{ |entry| entry.first }
  end

end
