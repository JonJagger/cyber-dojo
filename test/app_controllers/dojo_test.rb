#!/bin/bash ../test_wrapper.sh

require_relative 'AppControllerTestBase'

class DojoControllerTest < AppControllerTestBase

  test 'BF7103',
  'index without id' do
    get 'dojo/index'
    assert_response :success
  end

  test '120957',
  'index with id' do
    get 'dojo/index', id:'1234512345'
    assert_response :success
  end

  test '91778E',
  'check_id exists=false when no kata for id' do
    @id = 'abcdef'
    check_id
  end

  test '51690C',
  'check_id exists=true when id.length ~ 6 and kata exists' do
    [5,6,7].each do |n|
      create_kata
      @id = @id[0..(n-1)]
      assert_equal n, @id.length
      check_id
      refute empty?
      refute full?
    end
  end

  test 'AF2F15',
  'enter with no id raises RuntimeError' do
    assert_raises(RuntimeError) { enter }
  end

  test '9AFB84',
  'enter with empty string id raises RuntimeError' do
    @id = ''
    assert_raises(RuntimeError) { enter }
  end

  test 'E16A79',
  'enter with id that does not exist raises RuntimeError' do
    @id = 'ab00ab11ab'
    assert_raise(RuntimeError) { enter }
  end

  test '812BEE',
  'enter with id that does exist => !full,avatar_name' do
    create_kata    
    enter
    refute empty?
    refute full?
    assert Avatars.names.include?(avatar_name)
  end
  
  test 'C0F2AE',
  'enter succeeds once for each avatar name, then dojo is full' do
    create_kata    
    Avatars.names.each do |avatar_name|
      enter
      refute full?
      assert_not_nil avatar_name
    end
    enter
    refute empty?
    assert full?
    assert_nil avatar_name
  end

  test '3B15BD',
  're_enter with id that exists but is empty' do
    create_kata    
    re_enter
    assert empty?
    refute full?
  end

  test 'CFFDEB',
  're_enter with id that exists and is not empty' do
    create_kata    
    enter
    re_enter
    refute empty?
    refute full?
  end
  
private
  
  def check_id
    params = { :format => :json, :id => @id }
    get 'dojo/check', params
    assert_response :success    
  end

  def empty?
    json['empty']
  end

  def full?
    json['full']
  end
  
end
