#!/bin/bash ../test_wrapper.sh

require_relative './app_models_test_base'

class SandboxTest < AppModelsTestBase

  test '721FF6',
  "avatar's sandbox == sandbox's avatar" do
    kata = make_kata
    avatar = kata.start_avatar(['hippo'])
    sandbox = avatar.sandbox
    assert_equal avatar, sandbox.avatar
  end

end
