#!/usr/bin/env ruby

require_relative 'controller_test_base'

class DashboardControllerTest < ControllerTestBase

  def setup
    super
    stub_setup
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
  
  test 'progress when animal has only amber traffic-lights' do
    enter     # 0
    amber_test  # 1
    progress
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def dashboard(hash =  {})
    hash[:id] = @id
    get 'dashboard/show', hash
    assert_response :success
  end

  def heartbeat
    get 'dashboard/heartbeat', format: :js, id: @id    
    assert_response :success
  end

  def progress  
    get 'dashboard/progress', format: :js, id: @id
    assert_response :success
  end
  
end
