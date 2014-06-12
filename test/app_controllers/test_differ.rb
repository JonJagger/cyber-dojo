#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DifferControllerTest < IntegrationTest

  def setup
    super
    Thread.current[:runner] = HostTestRunner.new
  end

  def teardown
    Thread.current[:runner] = nil
  end

  test "no lines different in any files between successive tags" do
    id = checked_save_id
    get 'dojo/enter_json', :id => id
    avatar_name = json['avatar_name']
    post '/kata/edit', :id => id, :avatar => avatar_name
    post 'kata/run_tests', # 1
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => "wibble"
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }

    post 'kata/run_tests', # 2
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => "wibble"
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }

    get 'differ/diff',
      :format => :json,
      :id => id,
      :avatar => avatar_name,
      :was_tag => 1,
      :now_tag => 2

    assert_response :success
    info = " " + id + ":" + avatar_name

    was_traffic_light = json['wasTrafficLight']
    now_traffic_light = json['nowTrafficLight']
    diffs = json['diffs']

    assert_equal "amber", was_traffic_light['colour'], info
    assert_equal 1, was_traffic_light['number'], info

    assert_equal "amber", now_traffic_light['colour'], info
    assert_equal 2, now_traffic_light['number'], info

    assert_equal "cyber-dojo.sh", diffs[0]['filename'], info
    assert_equal 0, diffs[0]['section_count'], info
    assert_equal 0, diffs[0]['deleted_line_count'], info
    assert_equal 0, diffs[0]['added_line_count'], info
    assert_equal "<same>wibble</same>", diffs[0]['content'], info
    assert_equal "<same><ln>1</ln></same>", diffs[0]['line_numbers'], info

    assert_equal 'output', diffs[1]['filename']
    assert_equal 0, diffs[1]['section_count'], info
    assert_equal 0, diffs[1]['deleted_line_count'], info
    assert_equal 0, diffs[1]['added_line_count'], info
    assert_equal "<same>./cyber-dojo.sh: line 1: wibble: command not found</same>", diffs[1]['content'], info
    assert_equal "<same><ln>1</ln></same>", diffs[1]['line_numbers'], info
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "one line different in one file between successive tags" do
    Thread.current[:runner] = HostTestRunner.new
    id = checked_save_id
    get 'dojo/enter_json', :id => id
    avatar_name = json['avatar_name']
    post '/kata/edit', :id => id, :avatar => avatar_name

    post 'kata/run_tests', # 1
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => "tweedledee"
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }

    post 'kata/run_tests', # 2
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => "tweedledum"
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }

    get 'differ/diff',
      :format => :json,
      :id => id,
      :avatar => avatar_name,
      :was_tag => 1,
      :now_tag => 2

    assert_response :success
    info = " " + id + ":" + avatar_name + ":"

    was_traffic_light = json['wasTrafficLight']
    now_traffic_light = json['nowTrafficLight']
    diffs = json['diffs']

    assert_equal "amber", was_traffic_light['colour'], info
    assert_equal 1, was_traffic_light['number'], info

    assert_equal "amber", now_traffic_light['colour'], info
    assert_equal 2, now_traffic_light['number'], info

    assert_equal "cyber-dojo.sh", diffs[0]['filename'], info + "diffs[0][filename]"
    assert_equal 1, diffs[0]['section_count'], info + "diffs[0][section_count]"
    assert_equal 1, diffs[0]['deleted_line_count'], info + "diffs[0][deleted_line_count]"
    assert_equal 1, diffs[0]['added_line_count'], info + "diffs[0][added_line_count]"
    assert diffs[0]['content'].include?('<deleted>tweedledee</deleted>')
    assert diffs[0]['content'].include?('<added>tweedledum</added>')
    assert_equal "<deleted><ln>1</ln></deleted><added><ln>1</ln></added>", diffs[0]['line_numbers'], info + "diffs[0][line_numbers]"

    assert_equal 'output', diffs[1]['filename'], info + "diffs[1][filename]"
    assert_equal 1, diffs[1]['section_count'], info + "diffs[1][section_count]"
    assert_equal 1, diffs[1]['deleted_line_count'], info + "diffs[1][deleted_line_count]"
    assert_equal 1, diffs[1]['added_line_count'], info + "diffs[1][added_line_count]"
    assert diffs[1]['content'].include?("<deleted>./cyber-dojo.sh: line 1: tweedledee: command not found</deleted>"), info + "diffs[1][content]"
    assert diffs[1]['content'].include?("<added>./cyber-dojo.sh: line 1: tweedledum: command not found</added>"), info + "diffs[1][content]"
    assert_equal "<deleted><ln>1</ln></deleted><added><ln>1</ln></added>", diffs[1]['line_numbers'], info + "diffs[0][line_numbers]"
  end

end
