#!/bin/bash ../test_wrapper.sh

require_relative 'AppModelTestBase'

class SandboxTests < AppModelTestBase

  test 'B7E4D5',
  'sandbox has correct path format' do
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    sandbox = avatar.sandbox
    assert correct_path_format?(sandbox)
    assert sandbox.path.include?('sandbox')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '721FF6',
  "avatar's sandbox == sandbox's avatar" do
    kata = katas['45ED23A2F1']
    avatar = kata.avatars['hippo']
    sandbox = avatar.sandbox
    assert_equal avatar, sandbox.avatar
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2D9F15',
  'dir is not initially created' do
    kata = katas['45ED23A2F1']
    avatar = kata.avatars['hippo']
    sandbox = avatar.sandbox
    refute sandbox.dir.exists?
  end

end
