#!/bin/bash ../test_wrapper.sh

require_relative './AppControllerTestBase'
require_relative './ParamsMaker'

class KataControllerTest  < AppControllerTestBase

  test '9390F6',
  'edit and then run-tests' do
    create_kata('C (gcc), assert')
    enter
    avatar = katas[@id].avatars[@avatar_name]
    kata_edit

    params_maker = ParamsMaker.new(avatar)
    kata_run_tests params_maker.params
    assert_response :success

    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file('hiker.h', 'syntax-error')
    kata_run_tests params_maker.params
    assert_response :success
  end
  
end
