#!/bin/bash ../test_wrapper.sh

require_relative 'controller_test_base'

class DashboardControllerTest < ControllerTestBase

  def setup
    super
    create_kata
  end
  
  test 'dashboard when no avatars' do
    dashboard
    options = [ false, true, 'xxx' ]
    options.each do |mc|
      options.each do |ar|
        dashboard minute_columns: mc, auto_refresh: ar
      end
    end
    # How do I test @attributes in the controller object?
  end

  test 'dashboard when avatars with no traffic-lights' do
    4.times { enter }
    dashboard
  end

  test 'dashboard when avatars with some traffic lights' do
    3.times { enter; 2.times { any_test } }
    dashboard
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'heartbeat when no avatars' do
    heartbeat
  end

  test 'heartbeat when avatars with no traffic-lights' do    
    3.times { enter; 2.times { any_test } }
    heartbeat
  end
    
  test 'heartbeat when some traffic-lights' do
    enter     # 0
    any_test  # 1
    heartbeat
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'progress when no avatars' do
    progress
  end

  test 'progress when avatars with no traffic-lights' do
    enter # 0
    progress
  end
  
  test 'progress when avatar has only amber traffic-lights' do
    set_runner_class_name('RunnerStub')
    enter                     # 0
    stub_test_output(:amber)  # 1
    progress
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def dashboard(params = {})
    params[:id] = @id
    get 'dashboard/show', params
    assert_response :success
  end

  def heartbeat
    params = { :format => :js, :id => @id }
    get 'dashboard/heartbeat', params    
    assert_response :success
  end

  def progress
    params = { :format => :js, :id => @id }
    get 'dashboard/progress', params
    assert_response :success
  end
  
end
