#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'
require_relative './RailsRunnerStubThreadAdapter'

class ReverterControllerTest  < AppControllerTestBase

  def setup
    super
    set_runner_class('RailsRunnerStubThreadAdapter')
    RailsRunnerStubThreadAdapter.reset
    @id = create_kata('Java, JUnit')
    @avatar = enter
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '81F276',
  'revert' do
    kata_edit
    filename = 'Hiker.java'
    change_file(filename, old_content='echo abc')
    runner.stub_output('dummy')
    run_tests # 1
    assert_equal old_content, @avatar.visible_files[filename]
    change_file(filename, new_content='something different')
    runner.stub_output('dummy')
    run_tests # 2
    assert_equal new_content, @avatar.visible_files[filename]

    get 'reverter/revert', :format => :json,
                           :id     => @id,
                           :avatar => @avatar.name,
                           :tag    => 1
    assert_response :success

    visible_files = json['visibleFiles']
    refute_nil visible_files
    refute_nil visible_files['output']
    refute_nil visible_files[filename]
    assert_equal old_content, visible_files[filename]
  end

end
