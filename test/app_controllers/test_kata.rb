#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class KataControllerTest  < AppControllerTestBase

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
  'run_tests() saves changed makefile with leading spaces converted to tabs' +
    ' and these changes are made to the visible_files parameter too' +
    ' so they also occur in the manifest file' do
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
  'run_tests() saves *new* makefile with leading spaces converted to tabs' +
    ' and these changes are made to the visible_files parameter too' +
    ' so they also occur in the manifest file' do
    create_kata('C (gcc), assert')
    @avatar = start
    delete_file(makefile)
    run_tests
    new_file(makefile, makefile_with_leading_spaces)
    run_tests
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
