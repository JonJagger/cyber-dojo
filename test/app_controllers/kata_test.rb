#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class KataControllerTest  < AppControllerTestBase

  prefix = 'BE8'

  test prefix+'76E',
  'run_tests with bad kata id raises' do
    params = { :format => :js, :id => 'bad' }
    assert_raises(StandardError) { post 'kata/run_tests', params }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'3FD',
  'run_tests with good kata id but bad avatar name raises' do
    kata_id = create_kata('C (gcc), assert')
    params = { :format => :js, :id => kata_id, :avatar => 'bad' }
    assert_raises(StandardError) { post 'kata/run_tests', params }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'B75',
  'show-json (for Atom editor)' do
    create_kata('C (gcc), assert')
    @avatar = start
    kata_edit
    run_tests
    params = { :format => :json, :id => @id, :avatar => @avatar.name }
    get 'kata/show_json', params
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'0F6',
  'edit and then run-tests' do
    create_kata('C (gcc), assert')
    @avatar = start
    kata_edit
    run_tests
    change_file('hiker.h', 'syntax-error')
    run_tests
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'7FD',
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

  test prefix+'7AF',
  'run_tests() saves *new* makefile with leading spaces converted to tabs',
  'and these changes are made to the visible_files parameter too',
  'so they also occur in the manifest file' do

    skip # XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

    create_kata('C (gcc), assert')
    @avatar = start
    delete_file(makefile)
    run_tests
    new_file(makefile, makefile_with_leading_spaces)
    run_tests
    assert_file makefile, makefile_with_leading_tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'9DC',
  'when cyber-dojo.sh removes a file then on the next test it stays removed' do

    create_kata('C (gcc), assert')
    @avatar = start
    hit_test
    before = content('cyber-dojo.sh')
    filename = 'wibble.txt'
    create_file =
      "touch #{filename} \n" +
      "ls -al \n" +
      before
    change_file('cyber-dojo.sh', create_file)
    hit_test
    output = @avatar.visible_files['output']
    p output
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
