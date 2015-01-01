#!/usr/bin/env ruby

require_relative 'controller_test_base'

class DashboardControllerTest < ControllerTestBase

  test 'show no avatars' do
    stub_setup
    show_dashboard
    show_dashboard :minute_columns => false, :auto_refresh => false
    # How do I test @attributes in the controller object?
    show_dashboard :minute_columns => false, :auto_refresh => true
    show_dashboard :minute_columns => true,  :auto_refresh => false
    show_dashboard :minute_columns => true,  :auto_refresh => false
    show_dashboard :minute_columns => 'xxx', :auto_refresh => false
    show_dashboard :minute_columns => true,  :auto_refresh => 'xxx'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show avatars but no traffic-lights' do
    stub_setup
    4.times { enter }
    show_dashboard
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show avatars with some traffic lights' do
    stub_setup
    3.times { enter; 2.times { any_test } }
    show_dashboard
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show dashboard and open a history-dialog' do
    stub_setup
    enter; 3.times { any_test }
    show_dashboard :avatar => @avatar_name,
      :was_tag => 1,
      :now_tag => 2
    # Can I test the history-dialog has opened?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'heartbeat' do
    stub_setup
    enter     # 0
    any_test  # 1
    get 'dashboard/heartbeat', :format => :js, :id => @id
  end

end
