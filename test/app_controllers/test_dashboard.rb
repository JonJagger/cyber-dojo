#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class DashboardControllerTest < AppControllerTestBase

  def setup
    super
    set_runner_class('RunnerMock')
    # once that external has been accessed, its dojo @runner ||= code
    # means it can't be reset...
    # Note that merely writing runner.class.name in the assert uses
    # runner and therefore causes the @runner ||= code to run!
    assert_equal 'RunnerMock', runner.class.name
    create_kata
  end

  #- - - - - - - - - - - - - - - -

  test '62A971',
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

  test 'B4329E',
  'dashboard when avatars with no traffic-lights' do
    4.times { start }
    dashboard
  end

  #- - - - - - - - - - - - - - - -

  test '20AE43',
  'dashboard when avatars with some traffic lights' do
    3.times { start; 2.times { run_tests } }
    dashboard
  end

  #- - - - - - - - - - - - - - - -

  test '7906CB',
  'heartbeat when no avatars' do
    heartbeat
  end

  #- - - - - - - - - - - - - - - -

  test '1AB1FB',
  'heartbeat when avatars with no traffic-lights' do
    start
    heartbeat
  end

  #- - - - - - - - - - - - - - - -

  test '674785',
  'heartbeat when some traffic-lights' do
    3.times { start; 2.times { run_tests } }
    heartbeat
  end

  #- - - - - - - - - - - - - - - -

  test '904330',
  'progress when no avatars' do
    progress
  end

  #- - - - - - - - - - - - - - - -

  test '220619',
  'progress when avatars with no traffic-lights' do
    start # 0
    progress
  end

  #- - - - - - - - - - - - - - - -

  test '3B04FE',
  'progress when avatar has only amber traffic-lights' do
    start # 0
    runner.mock_run_colour(@avatar, :amber)
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
