#!/bin/bash ../test_wrapper.sh

require_relative 'AppControllerTestBase'
require_relative 'RailsRunnerStubThreadAdapter'
require_relative 'ParamsMaker'

class ReverterControllerTest  < AppControllerTestBase

  test 'revert' do
    set_runner_class('RailsRunnerStubThreadAdapter')
    @id = create_kata('Java, JUnit')
    enter
    avatar = katas[@id].avatars[@avatar_name]
    kata_edit

    filename = 'Hiker.java'
    assert avatar.visible_files.keys.include?(filename)
    # 1
    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file(filename, old_content='echo abc')
    runner.stub_output('dummy')
    kata_run_tests params_maker.params
    assert_response :success
    assert_equal old_content,avatar.visible_files[filename]
    # 2
    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file(filename, new_content='something different')
    runner.stub_output('dummy')
    kata_run_tests params_maker.params
    assert_response :success
    assert_equal new_content,avatar.visible_files[filename]

    get 'reverter/revert', :format => :json,
                           id:@id,
                           avatar:@avatar_name,
                           tag:1
    assert_response :success

    visible_files = json['visibleFiles']
    refute_nil visible_files
    refute_nil visible_files['output']
    refute_nil visible_files[filename]
    assert_equal old_content, visible_files[filename]
  end

end
