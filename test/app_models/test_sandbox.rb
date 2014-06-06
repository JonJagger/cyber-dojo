#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class SandboxTests < ModelTestCase

  test "avatar's sandbox == sandbox's avatar" do
    json_and_rb do
      kata = @dojo.katas['45ED23A2F1']
      avatar = kata.avatars['hippo']
      sandbox = avatar.sandbox
      assert_equal avatar, sandbox.avatar
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir is not created until file is saved' do
    json_and_rb do
      kata = @dojo.katas['45ED23A2F1']
      avatar = kata.avatars['hippo']
      sandbox = avatar.sandbox
      assert !@paas.dir(sandbox).exists?
      sandbox.write('filename', 'content')
      assert @paas.dir(sandbox).exists?
    end
  end

end
