#!/bin/bash ../test_wrapper.sh

require_relative './AppControllerTestBase'

class DifferControllerTest < AppControllerTestBase

  test '238AF6',
  'no lines different in any files between successive tags' do
    @id = create_kata('Java, JUnit')
    @avatar = enter # 0
    filename = 'Hiker.java'
    change_file(filename, content = '#include...')
    run_tests
    run_tests
    @was_tag,@now_tag = 1,2
    differ
    lights = json['lights']
    info = " " + @id + ":" + @avatar.name
    was_light = lights[@was_tag-1]
    assert_equal 'amber', was_light['colour'], info
    assert_equal @was_tag, was_light['number'], info
    now_light = lights[@now_tag-1]
    assert_equal 'amber', now_light['colour'], info
    assert_equal @now_tag, now_light['number'], info
    diffs = json['diffs']
    index = diffs.find_index{|diff| diff['filename'] == filename }
    assert_equal filename, diffs[index]['filename'], info
    assert_equal 0, diffs[index]['section_count'], info
    assert_equal 0, diffs[index]['deleted_line_count'], info
    assert_equal 0, diffs[index]['added_line_count'], info
    assert_equal "<same>#{content}</same>", diffs[index]['content'], info
    assert_equal '<same><ln>1</ln></same>', diffs[index]['line_numbers'], info
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BEC2BF',
  'one line different in one file between successive tags' do
    @id = create_kata
    @avatar = enter # 0
    filename = 'hiker.rb'
    change_file(filename, 'def fubar')
    run_tests
    change_file(filename, 'def snafu')
    run_tests
    @was_tag,@now_tag = 1,2
    differ
    lights = json['lights']
    info = " " + @id + ':' + @avatar.name + ':'
    was_light = lights[@was_tag-1]
    assert_equal 'amber', was_light['colour'], info
    assert_equal @was_tag, was_light['number'], info
    now_light = lights[@now_tag-1]
    assert_equal 'amber', now_light['colour'], info
    assert_equal @now_tag, now_light['number'], info
    diffs = json['diffs']
    index = diffs.find_index{|diff| diff['filename'] == filename }
    assert_equal filename, diffs[index]['filename'], info + "diffs[#{index}]['filename']"
    assert_equal 1, diffs[index]['section_count'], info + "diffs[#{index}]['section_count']"
    assert_equal 1, diffs[index]['deleted_line_count'], info + "diffs[#{index}]['deleted_line_count']"
    assert_equal 1, diffs[index]['added_line_count'], info + "diffs[#{index}]['added_line_count']"
    assert diffs[index]['content'].include?('<deleted>def fubar</deleted>')
    assert diffs[index]['content'].include?('<added>def snafu</added>')
    assert_equal '<deleted><ln>1</ln></deleted><added><ln>1</ln></added>',
        diffs[index]['line_numbers'], info + "diffs[0]['line_numbers']"
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '06FD09',
  'tag -1 gives last traffic-light' do
    @id = create_kata
    enter      # 0
    run_tests  # 1
    run_tests  # 2
    @was_tag,@now_tag = -1,-1
    differ
    assert_equal 2, json['wasTag']
    assert_equal 2, json['nowTag']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '34D490',
  'nextAvatar and prevAvatar are empty string for dojo with one avatar' do
    @id = create_kata
    enter     # 0
    run_tests  # 1
    @was_tag,@now_tag = 0,1
    differ
    assert_equal '', json['prevAvatar']
    assert_equal '', json['nextAvatar']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9FF76A',
  'nextAvatar and prevAvatar for dojo with two avatars' do
    @id = create_kata
    firstAvatar = enter  # 0
    run_tests            # 1
    enter      # 0
    run_tests  # 1
    @was_tag,@now_tag = 0,1
    differ
    assert_equal firstAvatar.name, json['prevAvatar']
    assert_equal firstAvatar.name, json['nextAvatar']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def differ
    params = {
      :format  => :json,
      :id      => @id,
      :avatar  => @avatar.name,
      :was_tag => @was_tag,
      :now_tag => @now_tag
    }
    get 'differ/diff', params
    assert_response :success
  end

end
