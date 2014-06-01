#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class SandboxTests < ModelTestCase

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

  # These all belong in avatar_tests now

  test "after test() output-file is not saved in sandbox " +
         "and output-file is not inserted into the visible_files argument" do
    json_and_rb do
      kata = @dojo.katas['45ED23A2F1']
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
      avatar.save(delta, visible_files)
      output = avatar.test(@max_duration)
      assert_equal 'stubbed-output', output
      assert !visible_files.keys.include?('output')
      saved_filenames = filenames_written_to_in(@paas.dir(sandbox).log)
      assert !saved_filenames.include?('output')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save():delta[:changed] files are saved" do
    json_and_rb do
      avatar = @dojo.katas['45ED23A2F1'].avatars['hippo']
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
      avatar.save(delta, visible_files)
      output = avatar.test(@max_duration)
      log = @paas.dir(sandbox).log
      saved_filenames = filenames_written_to_in(log)
      assert_equal delta[:changed].sort, saved_filenames.sort
      assert log.include?(['write','untitled.cs', 'content for code file' ]), log.inspect
      assert log.include?(['write','untitled.test.cs', 'content for test file' ]), log.inspect
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save():delta[:unchanged] files are not saved" do
    json_and_rb do
      avatar = @dojo.katas['45ED23A2F1'].avatars['hippo']
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
      avatar.save(delta, visible_files)
      saved_filenames = filenames_written_to_in(@paas.dir(sandbox).log)
      assert_equal delta[:changed].sort, saved_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save():delta[:new] files are saved and git added" do
    json_and_rb do
      avatar = @dojo.katas['45ED23A2F1'].avatars['hippo']
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
      avatar.save(delta, visible_files)
      saved_filenames = filenames_written_to_in(@paas.dir(sandbox).log)
      assert_equal delta[:new].sort, saved_filenames.sort
      git_log = @git.log[@paas.path(sandbox)]
      assert git_log.include?([ 'add', 'wibble.cs' ]), git_log.inspect
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "save():delta[:deleted] files are git rm'd" do
    json_and_rb do
      avatar = @dojo.katas['45ED23A2F1'].avatars['hippo']
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
      avatar.save(delta, visible_files)
      saved_filenames = filenames_written_to_in(@paas.dir(sandbox).log)
      assert !saved_filenames.include?('wibble.cs'), saved_filenames.inspect

      git_log = @git.log[@paas.path(sandbox)]
      assert git_log.include?([ 'rm', 'wibble.cs' ]), git_log.inspect
    end
  end

end
