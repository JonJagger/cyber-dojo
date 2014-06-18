#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class SandboxTests < ModelTestCase

  test 'path(avatar)' do
    json_and_rb do |format|
      kata = make_kata
      avatar = kata.start_avatar(Avatar.names)
      sandbox = avatar.sandbox
      assert path_ends_in_slash?(sandbox)
      assert !path_has_adjacent_separators?(sandbox)
      assert sandbox.path.include?('sandbox')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
      assert !sandbox.dir.exists?
      sandbox.write('filename', 'content')
      assert sandbox.dir.exists?
    end
  end

end
