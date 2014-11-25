#!/usr/bin/env ruby

require_relative 'controller_test_base'

class DashboardControllerTest < ControllerTestBase

  test 'show no avatars' do
    stub_setup
    show_dashboard
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show avatars but no traffic-lights' do
    stub_setup
    4.times do
      enter
      kata_edit
    end
    show_dashboard
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show avatars with some traffic lights' do
    stub_setup
    3.times do
      enter
      kata_edit
      2.times { any_test }
    end
    show_dashboard
    show_dashboard :minute_columns => false
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show dashboard and open a diff-dialog' do
    @id = create_kata
    enter
    kata_edit
    3.times { any_test }
    show_dashboard :avatar => @avatar_name,
      :was_tag => 1,
      :now_tag => 2
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'heartbeat' do
    stub_setup
    enter
    kata_edit # 0
    any_test  # 1
    get 'dashboard/heartbeat', :format => :js, :id => @id
  end

end
