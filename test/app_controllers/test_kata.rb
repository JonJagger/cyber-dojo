#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class KataControllerTest  < AppControllerTestBase

  test 'E1F76E',
  'run_tests with bad kata id raises' do
    params = { :format => :js, :id => 'bad' }
    assert_raises(StandardError) { post 'kata/run_tests', params }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '80C3FD',
  'run_tests with good kata id but bad avatar name raises' do
    kata_id = create_kata('C (gcc), assert')
    params = { :format => :js, :id => kata_id, :avatar => 'bad' }
    assert_raises(StandardError) { post 'kata/run_tests', params }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9390F6',
  'edit and then run-tests' do
    create_kata('C (gcc), assert')
    @avatar = start
    kata_edit
    run_tests
    change_file('hiker.h', 'syntax-error')
    run_tests
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'D0E7FD',
  'run_tests() saves changed makefile with leading spaces converted to tabs',
  'and these changes are made to the visible_files parameter too',
  'so they also occur in the manifest file' do
    create_kata('C (gcc), assert')
    @avatar = start
    kata_edit
    run_tests
    change_file(makefile, makefile_with_leading_spaces)
    run_tests
    assert_file makefile, makefile_with_leading_tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B547AF',
  'run_tests() saves *new* makefile with leading spaces converted to tabs',
  'and these changes are made to the visible_files parameter too',
  'so they also occur in the manifest file' do
    skip
    create_kata('C (gcc), assert')
    @avatar = start
    delete_file(makefile)
    run_tests
    new_file(makefile, makefile_with_leading_spaces)
    run_tests
    # now katas/runner are separated this state is not visible
    # need to get files seen by stub-runner
    assert_file makefile, makefile_with_leading_tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_file(filename, expected)
    assert_equal expected, @avatar.visible_files[filename], 'saved_to_manifest'
    assert_equal expected, katas.dir(@avatar.sandbox).read(filename), 'saved_to_sandbox'
  end

  def makefile_with_leading_tab
    makefile_with_leading("\t")
  end

  def makefile_with_leading_spaces
    makefile_with_leading(' ' + ' ')
  end

  def makefile_with_leading(s)
    [
      "CFLAGS += -I. -Wall -Wextra -Werror -std=c11",
      "test: makefile $(C_FILES) $(COMPILED_H_FILES)",
      s + "@gcc $(CFLAGS) $(C_FILES) -o $@"
    ].join("\n")
  end

  def makefile
    'makefile'
  end

end
