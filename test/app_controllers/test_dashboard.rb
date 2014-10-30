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
    (1..4).each do |n|
      enter
      kata_edit
      assert_response :success
    end
    show_dashboard
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show avatars with some traffic lights' do
    stub_setup
    (1..3).each do |n|
      enter
      kata_edit
      assert_response :success
      (1..2).each do |m|
        kata_run_tests :file_content => {
            'cyber-dojo.sh' => ""
          },
          :file_hashes_incoming => {
            'cyber-dojo.sh' => 234234
          },
          :file_hashes_outgoing => {
            'cyber-dojo.sh' => -4545645678
          }
      end
    end
    show_dashboard
    show_dashboard :minute_columns => false
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show dashboard and open a diff-dialog' do
    @id = create_kata
    enter
    kata_edit
    assert_response :success
    (1..3).each do |m|
      kata_run_tests :file_content => {
          'cyber-dojo.sh' => ''
        },
        :file_hashes_incoming => {
          'cyber-dojo.sh' => 234234
        },
        :file_hashes_outgoing => {
          'cyber-dojo.sh' => -4545645678
        }
    end
    show_dashboard :avatar => @avatar_name,
      :was_tag => 1,
      :now_tag => 2
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'heartbeat' do
    stub_setup
    enter
    kata_edit
    assert_response :success

    kata_run_tests :file_content => {
        'cyber-dojo.sh' => ''
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }

    get 'dashboard/heartbeat', :format => :js, :id => @id
  end

end
