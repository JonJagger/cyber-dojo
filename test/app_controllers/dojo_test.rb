#!/bin/bash ../test_wrapper.sh

require_relative 'controller_test_base'

class DojoControllerTest < ControllerTestBase

  test 'index without id' do
    get 'dojo/index'
    assert_response :success
  end

  test 'index with id' do
    get 'dojo/index', id:'1234512345'
    assert_response :success
  end

  test 'check_id exists=false when no kata for id' do
    @id = 'abcdef'
    check_id
  end

  test 'check_id exists=true when id.length ~ 6 and kata exists' do
    [5,6,7].each do |n|
      create_kata
      @id = @id[0..(n-1)]
      assert_equal n, @id.length
      check_id
      assert !empty?
      assert !full?
    end
  end

  test 'enter with no id raises RuntimeError' do
    assert_raises(RuntimeError) { enter }
  end

  test 'enter with empty string id raises RuntimeError' do
    @id = ''
    assert_raises(RuntimeError) { enter }
  end

  #test 'enter with id that does not exist raises RuntimeError' do
  #  @id = 'ab00ab11ab'
  #  assert_raise(RuntimeError) { enter }
  #end
  
  test 'enter with id that does exist => !full,avatar_name' do
    create_kata    
    enter
    assert !empty?
    assert !full?
    assert Avatars.names.include?(avatar_name)
  end
  
  test 'enter succeeds once for each avatar name, then dojo is full' do
    create_kata    
    Avatars.names.each do |avatar_name|
      enter
      assert !full?
      assert_not_nil avatar_name
    end
    enter
    assert !empty?
    assert full?
    assert_nil avatar_name
  end

  test 're_enter with id that does not exist' do
    @id = 'ab00ab11ab'
    re_enter
  end

  test 're_enter with id that exists but is empty' do
    create_kata    
    re_enter
    assert empty?
    assert !full?
  end

  test 're_enter with id that exists and is not empty' do
    create_kata    
    enter
    re_enter
    assert !empty?
    assert !full?
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
