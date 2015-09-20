#!/bin/bash ../test_wrapper.sh

require_relative './AppControllerTestBase'
require_relative './ParamsMaker'

class DifferControllerTest < AppControllerTestBase

  test '238AF6',
  'no lines different in any files between successive tags' do
    @id = create_kata('C++, assert')
    enter # 0
    avatar = katas[@id].avatars[@avatar_name]
    filename = 'hiker.cpp'
    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file(filename, 'wibble')
    kata_run_tests params_maker.params # 1
    kata_run_tests params_maker.params # 2
    @was_tag,@now_tag = 1,2
    differ
    lights = json['lights']
    info = " " + @id + ":" + @avatar_name
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
    assert_equal '<same>wibble</same>', diffs[index]['content'], info
    assert_equal '<same><ln>1</ln></same>', diffs[index]['line_numbers'], info
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'BEC2BF',
  'one line different in one file between successive tags' do
    @id = create_kata
    enter # 0
    avatar = katas[@id].avatars[@avatar_name]
    filename = 'hiker.rb'

    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file(filename, 'def fubar')
    kata_run_tests params_maker.params # 1

    params_maker = ParamsMaker.new(avatar)
    params_maker.change_file(filename, 'def snafu')
    kata_run_tests params_maker.params # 2

    @was_tag,@now_tag = 1,2
    differ
    lights = json['lights']
    info = " " + @id + ':' + @avatar_name + ':'
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
    enter     # 0
    any_test  # 1
    any_test  # 2
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
    any_test  # 1
    @was_tag,@now_tag = 0,1
    differ
    assert_equal '', json['prevAvatar']
    assert_equal '', json['nextAvatar']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '9FF76A',
  'nextAvatar and prevAvatar for dojo with two avatars' do
    @id = create_kata
    firstAvatar = enter # 0
    any_test  # 1
    secondAvatar = enter # 0
    any_test  # 1
    @was_tag,@now_tag = 0,1
    @avatar_name = firstAvatar
    differ
    assert_equal secondAvatar, json['prevAvatar']
    assert_equal secondAvatar, json['nextAvatar']
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def differ
    params = {
      :format => :json,
      :id => @id,
      :avatar => @avatar_name,
      :was_tag => @was_tag,
      :now_tag => @now_tag
    }
    get 'differ/diff', params
    assert_response :success
  end
  
end
