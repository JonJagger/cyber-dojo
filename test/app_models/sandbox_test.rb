#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class SandboxTests < ModelTestBase

  test 'path(avatar)' do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    sandbox = avatar.sandbox
    assert path_ends_in_slash?(sandbox)
    assert path_has_no_adjacent_separators?(sandbox)
    assert sandbox.path.include?('sandbox')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "avatar's sandbox == sandbox's avatar" do
    kata = katas['45ED23A2F1']
    avatar = kata.avatars['hippo']
    sandbox = avatar.sandbox
    assert_equal avatar, sandbox.avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir is not initially created' do
    kata = katas['45ED23A2F1']
    avatar = kata.avatars['hippo']
    sandbox = avatar.sandbox
    assert !sandbox.dir.exists?
  end

end
