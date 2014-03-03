require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'
require File.dirname(__FILE__) + '/stub_git'
require File.dirname(__FILE__) + '/stub_runner'

class SandboxTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    Thread.current[:git] = @git = StubGit.new
    Thread.current[:runner] = @stub_runner = StubRunner.new
    @id = '45ED23A2F1'
  end

  def teardown
    @disk.teardown
    Thread.current[:disk] = nil
    Thread.current[:git] = nil
    Thread.current[:runner] = nil
  end

  def rb_and_json(&block)
    block.call('rb')
    teardown
    setup
    block.call('json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no disk on thread the ctor raises" do
    Thread.current[:disk] = nil
    error = assert_raises(RuntimeError) { Sandbox.new(nil) }
    assert_equal 'no disk', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no git on thread the ctor raises" do
    Thread.current[:git] = nil
    error = assert_raises(RuntimeError) { Sandbox.new(nil) }
    assert_equal 'no git', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no runner on thread the ctor raises" do
    Thread.current[:runner] = nil
    error = assert_raises(RuntimeError) { Sandbox.new(nil) }
    assert_equal 'no runner', error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path ends in slash" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
      assert sandbox.path.end_with?(@disk.dir_separator)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path does not have doubled separator" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
      doubled_separator = @disk.dir_separator * 2
      assert_equal 0, sandbox.path.scan(doubled_separator).length
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir is not created until file is saved" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
      assert !sandbox.dir.exists?
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "after test() output-file has to be explicitly saved in sandbox " +
         "and output-file is not inserted into the visible_files argument" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
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
      sandbox.write(delta, visible_files)
      output = sandbox.test()
      assert_equal "stubbed-output", output
      avatar.sandbox.dir.write('output', output) # so output appears in diff-view

      assert !visible_files.keys.include?('output')
      assert output.class == String, 'output.class == String'
      assert_equal ['write','output',output], sandbox.dir.log.last
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "write():delta[:changed] files are saved" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
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
      sandbox.write(delta, visible_files)
      output = sandbox.test()
      sandbox.dir.write('output', output)

      log = sandbox.dir.log
      saved_files = filenames_written_to_in(log)
      assert_equal ['output', 'untitled.cs', 'untitled.test.cs'], saved_files.sort
      assert log.include?(['write','untitled.cs', 'content for code file' ]), log.inspect
      assert log.include?(['write','untitled.test.cs', 'content for test file' ]), log.inspect
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "write():delta[:unchanged] files are not saved" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
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
      sandbox.write(delta, visible_files)
      saved_files = filenames_written_to_in(sandbox.dir.log)
      assert !saved_files.include?('cyber-dojo.sh'), saved_files.inspect
      assert !saved_files.include?('untitled.test.cs'), saved_files.inspect
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "write():delta[:new] files are saved and git added" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
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
      sandbox.write(delta, visible_files)
      saved_files = filenames_written_to_in(sandbox.dir.log)
      assert saved_files.include?('wibble.cs'), saved_files.inspect

      git_log = @git.log[sandbox.path]
      assert git_log.include?([ 'add', 'wibble.cs' ]), git_log.inspect
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "write():delta[:deleted] files are git rm'd" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new('spied/', format)
      kata = dojo[@id]
      avatar = kata['hippo']
      sandbox = avatar.sandbox
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
      sandbox.write(delta, visible_files)
      saved_files = filenames_written_to_in(sandbox.dir.log)
      assert !saved_files.include?('wibble.cs'), saved_files.inspect

      git_log = @git.log[sandbox.path]
      assert git_log.include?([ 'rm', 'wibble.cs' ]), git_log.inspect
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def filenames_written_to_in(log)
    # each log entry is of the form
    #  [ 'read'/'write',  filename, content ]
    log.select { |entry| entry[0] == 'write' }.collect{ |entry| entry[1] }
  end

end
