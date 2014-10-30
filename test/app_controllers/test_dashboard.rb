#!/usr/bin/env ruby

require_relative 'controller_test_base'

class DashboardControllerTest < ControllerTestBase

  test 'show no avatars' do
    stub_setup
    show_dashboard
    assert_response :success
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show avatars but no traffic-lights' do
    stub_setup
    (1..4).each do |n|
      enter
      avatar_name = json['avatar_name']
      setup_initial_edit(@id,avatar_name)
      get 'kata/edit', :id => @id, :avatar => avatar_name
      assert_response :success
    end
    show_dashboard
    assert_response :success
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show avatars with some traffic lights' do
    stub_setup
    (1..3).each do |n|
      enter
      avatar_name = json['avatar_name']
      get 'kata/edit', :id => @id, :avatar => avatar_name
      assert_response :success
      (1..2).each do |m|
        post 'kata/run_tests',
          :format => :js,
          :id => @id,
          :avatar => avatar_name,
          :file_content => {
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
    assert_response :success
    get 'dashboard/show',  :id => @id, :minute_columns => false
    assert_response :success
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'show dashboard and open a diff-dialog' do
    @id = create_kata
    enter
    avatar_name = json['avatar_name']
    get 'kata/edit', :id => @id, :avatar => avatar_name
    assert_response :success
    (1..3).each do |m|
      post 'kata/run_tests',
        :format => :js,
        :id => @id,
        :avatar => avatar_name,
        :file_content => {
          'cyber-dojo.sh' => ''
        },
        :file_hashes_incoming => {
          'cyber-dojo.sh' => 234234
        },
        :file_hashes_outgoing => {
          'cyber-dojo.sh' => -4545645678
        }
    end
    get 'dashboard/show',
      :id => @id,
      :avatar => avatar_name,
      :was_tag => 1,
      :now_tag => 2
    assert_response :success
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'heartbeat' do
    stub_setup
    get 'dojo/enter', :id => @id
    avatar_name = json['avatar_name']

    get 'kata/edit', :id => @id, :avatar => avatar_name
    assert_response :success

    post 'kata/run_tests',
      :format => :js,
      :id => @id,
      :avatar => avatar_name,
      :file_content => {
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

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def show_dashboard
    get 'dashboard/show', :id => @id
  end

end
