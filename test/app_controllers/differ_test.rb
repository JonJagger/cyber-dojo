#!/bin/bash ../test_wrapper.sh

require_relative 'AppControllerTestBase'

class DifferControllerTest < AppControllerTestBase

  test '238AF6',
  'no lines different in any files between successive tags' do
    @id = create_kata('C++, assert')
    enter # 0
    filename = 'hiker.cpp'
    kata_run_tests make_file_hash(filename,'#include <badname>',234234, -4545645678) #1
    kata_run_tests make_file_hash(filename,'wibble',-4545645678,-4545645678 ) #2
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
    filename = 'hiker.rb'
    kata_run_tests file_content:         { filename => 'def fubar' },
                   file_hashes_incoming: { filename => 234234 },
                   file_hashes_outgoing: { filename => -4545645678 } #1
    kata_run_tests file_content:         { filename => 'def snafu' },
                   file_hashes_incoming: { filename => -4545645678 },
                   file_hashes_outgoing: { filename => 654356 } #2
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
    assert_equal "", json['prevAvatar']
    assert_equal "", json['nextAvatar']
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
