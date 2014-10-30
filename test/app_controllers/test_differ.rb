#!/usr/bin/env ruby

require_relative 'controller_test_base'

class DifferControllerTest < ControllerTestBase

  def runner
    if Docker.installed?
      DockerTestRunner.new
    else
      HostTestRunner.new
    end
  end

  def setup
    super
    Thread.current[:runner] = runner
  end

  def teardown
    Thread.current[:runner] = nil
  end

  test 'no lines different in any files between successive tags' do
    @id = create_kata
    enter
    kata_edit

    filename = 'hiker.rb'
    kata_run_tests :file_content => { #1
        filename => 'wibble'
      },
      :file_hashes_incoming => {
        filename => 234234
      },
      :file_hashes_outgoing => {
        filename => -4545645678
      }

    kata_run_tests :file_content => { #2
        filename => 'wibble'
      },
      :file_hashes_incoming => {
        filename => -4545645678
      },
      :file_hashes_outgoing => {
        filename => -4545645678
      }

    was_tag = 1
    now_tag = 2
    get 'differ/diff',
      :format => :json,
      :id => @id,
      :avatar => @avatar_name,
      :was_tag => was_tag,
      :now_tag => now_tag

    assert_response :success
    info = " " + @id + ":" + @avatar_name

    lights = json['lights']

    was_light = lights[was_tag-1]
    assert_equal 'amber', was_light['colour'], info
    assert_equal was_tag, was_light['number'], info

    now_light = lights[now_tag-1]
    assert_equal 'amber', now_light['colour'], info
    assert_equal now_tag, now_light['number'], info

    diffs = json['diffs']
    assert_equal filename, diffs[0]['filename'], info
    assert_equal 0, diffs[0]['section_count'], info
    assert_equal 0, diffs[0]['deleted_line_count'], info
    assert_equal 0, diffs[0]['added_line_count'], info
    assert_equal '<same>wibble</same>', diffs[0]['content'], info
    assert_equal '<same><ln>1</ln></same>', diffs[0]['line_numbers'], info
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'one line different in one file between successive tags' do
    @id = create_kata
    enter
    kata_edit

    filename = 'hiker.rb'
    kata_run_tests :file_content => { #1
        filename => 'tweedledee'
      },
      :file_hashes_incoming => {
        filename => 234234
      },
      :file_hashes_outgoing => {
        filename => -4545645678
      }

    kata_run_tests :file_content => { #2
        filename => 'tweedledum'
      },
      :file_hashes_incoming => {
        filename => -4545645678
      },
      :file_hashes_outgoing => {
        filename => 654356
      }

    was_tag = 1
    now_tag = 2
    get 'differ/diff',
      :format => :json,
      :id => @id,
      :avatar => @avatar_name,
      :was_tag => was_tag,
      :now_tag => now_tag

    assert_response :success
    info = " " + @id + ':' + @avatar_name + ':'

    lights = json['lights']

    was_light = lights[was_tag-1]
    assert_equal 'amber', was_light['colour'], info
    assert_equal was_tag, was_light['number'], info

    now_light = lights[now_tag-1]
    assert_equal 'amber', now_light['colour'], info
    assert_equal now_tag, now_light['number'], info

    diffs = json['diffs']
    assert_equal filename, diffs[0]['filename'], info + "diffs[0]['filename']"
    assert_equal 1, diffs[0]['section_count'], info + "diffs[0]['section_count']"
    assert_equal 1, diffs[0]['deleted_line_count'], info + "diffs[0]['deleted_line_count']"
    assert_equal 1, diffs[0]['added_line_count'], info + "diffs[0]['added_line_count']"
    assert diffs[0]['content'].include?('<deleted>tweedledee</deleted>')
    assert diffs[0]['content'].include?('<added>tweedledum</added>')
    assert_equal '<deleted><ln>1</ln></deleted><added><ln>1</ln></added>', diffs[0]['line_numbers'], info + "diffs[0]['line_numbers']"
  end

end
