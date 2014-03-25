require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasSandboxTests < LinuxPaasModelTestCase

  test "avatar's sandbox -- sandbox's avatar" do
    json_and_rb do
      kata = @dojo.katas['45ED23A2F1']
      avatar = kata.avatars['hippo']
      sandbox = avatar.sandbox
      assert_equal avatar, sandbox.avatar
    end
  end

  test "dir is not created until file is saved" do
    json_and_rb do
      kata = @dojo.katas['45ED23A2F1']
      avatar = kata.avatars['hippo']
      sandbox = avatar.sandbox
      assert !@paas.dir(sandbox).exists?
      sandbox.write('filename', 'content')
      assert @paas.dir(sandbox).exists?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin

  # These all belong in avatar_tests now

  test "after test() output-file has to be explicitly saved in sandbox " +
         "and output-file is not inserted into the visible_files argument" do
    json_and_rb do
      id = '45ED23A2F1'
      kata = @dojo.katas[id]
      avatar = kata.avatars['hippo']
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
    end
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
=end

end
