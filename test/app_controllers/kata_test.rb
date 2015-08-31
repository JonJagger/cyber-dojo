#!/bin/bash ../test_wrapper.sh

require_relative 'controller_test_base'

class KataControllerTest  < ControllerTestBase

  test 'edit and then run-tests' do
    create_kata
    enter
    kata_edit
    filename = 'cyber-dojo.sh'
    kata_run_tests make_file_hash(filename, '', 234234, -4545645678) #1
    assert_response :success
    kata_run_tests make_file_hash(filename, '', 234234, -4545645678) #2
    assert_response :success
  end
  
end
