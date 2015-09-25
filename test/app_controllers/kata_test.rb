#!/bin/bash ../test_wrapper.sh

require_relative './AppControllerTestBase'

class KataControllerTest  < AppControllerTestBase

  test '9390F6',
  'edit and then run-tests' do
    create_kata('C (gcc), assert')
    @avatar = enter
    kata_edit
    run_tests
    change_file('hiker.h', 'syntax-error')
    run_tests
  end
  
end
