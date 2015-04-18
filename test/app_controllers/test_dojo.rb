#!/usr/bin/env ruby

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

  test 'check_id exists=true when id.length < 6 and kata exists' do
    @id = create_kata
    @id = @id[0..4]
    assert @id.length < 6
    check_id
    assert !empty?
    assert !full?
  end

  test 'check_id exists=true when id.length == 6 and kata exists' do
    @id = create_kata
    @id = @id[0..5]
    assert @id.length == 6
    check_id
    assert !empty?
    assert !full?
  end

  test 'check_id exists=true when id.length > 6 and kata exists' do
    @id = create_kata
    @id = @id[0..6]
    assert @id.length > 6
    check_id
    assert !empty?
    assert !full?
  end

  test 'enter with no id raises RuntimeError' do
    assert_raises(RuntimeError) { enter }
  end

=begin

  test 'enter with empty string id raises RuntimeError' do
    stub_setup
    @id = ''
    assert_raises(RuntimeError) { enter }
  end

  test 'enter with id that does not exist raises RuntimeError' do
    stub_setup
    @id = 'ab00ab11ab'
    assert_raise(RuntimeError) { enter }
  end

  test 'enter with id that does exist => !full,avatar_name' do
    stub_setup
    enter
    assert !empty?
    assert !full?
    assert Avatars.names.include?(avatar_name)
  end

  test 'enter succeeds once for each avatar name, then dojo is full' do
    stub_setup
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
    stub_setup
    @id = 'ab00ab11ab'
    re_enter
  end

  test 're_enter with id that exists but is empty' do
    stub_setup
    re_enter
    assert empty?
    assert !full?
  end

  test 're_enter with id that exists and is not empty' do
    stub_setup
    enter
    re_enter
    assert !empty?
    assert !full?
  end

  def re_enter(json = :json)
    get 'dojo/re_enter', format:json, id:@id
    assert_response :success    
  end

=end
  
  def check_id(json = :json)
    get 'dojo/check', format:json, id:@id
    assert_response :success    
  end

  def empty?
    json['empty']
  end

  def full?
    json['full']
  end
  
end
