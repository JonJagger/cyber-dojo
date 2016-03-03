#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class DashboardControllerTest < AppControllerTestBase

  def setup
    super
    create_kata
  end

  #- - - - - - - - - - - - - - - -

  prefix = '62A'

  test prefix+'971',
  'dashboard when no avatars' do
    dashboard
    options = [ false, true, 'xxx' ]
    options.each do |mc|
      options.each do |ar|
        dashboard minute_columns: mc, auto_refresh: ar
      end
    end
    # How do I test @attributes in the controller object?
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'29E',
  'dashboard when avatars with no traffic-lights' do
    4.times { start }
    dashboard
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'E43',
  'dashboard when avatars with some traffic lights' do
    3.times { start; 2.times { run_tests } }
    dashboard
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'6CB',
  'heartbeat when no avatars' do
    heartbeat
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'1FB',
  'heartbeat when avatars with no traffic-lights' do
    start
    heartbeat
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'785',
  'heartbeat when some traffic-lights' do
    3.times { start; 2.times { run_tests } }
    heartbeat
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'330',
  'progress when no avatars' do
    progress
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'619',
  'progress when avatars with no traffic-lights' do
    start # 0
    progress
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'4FE',
  'progress when avatar has only amber traffic-lights' do
    start # 0
    runner.stub_run_colour(@avatar, :amber)
    run_tests
    progress
  end

  #- - - - - - - - - - - - - - - -

  private

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
