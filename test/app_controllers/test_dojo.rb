#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class DojoControllerTest < AppControllerTestBase

  prefix = '103'

  test prefix+'BF7',
  'index without id' do
    get 'dojo/index'
    assert_response :success
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'957',
  'index with id' do
    get 'dojo/index', id:'1234512345'
    assert_response :success
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'78E',
  'check_id exists=false when no kata for id' do
    @id = 'abcdef'
    check_id
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'90C',
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

  #- - - - - - - - - - - - - - - -

  test prefix+'8EE',
  'show with no id' do
    get '/enter/show'
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'E3E',
  'show with an id' do
    create_kata
    get '/enter/show', { :id => @id }
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'F15',
  'start with no id raises' do
    assert_raises { start }
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'B84',
  'start with empty string id raises' do
    @id = ''
    assert_raises { start }
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'A79',
  'start with id that does not exist raises' do
    @id = 'ab00ab11ab'
    assert_raise { start }
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'BEE',
  'enter with id that does exist => !full,avatar_name' do
    create_kata
    start
    refute empty?
    refute full?
    assert Avatars.names.include?(@avatar.name)
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'2AE',
  'enter succeeds once for each avatar name, then dojo is full' do
    create_kata
    Avatars.names.each do |avatar_name|
      start
      refute full?
      assert Avatars.names.include? json['avatar_name']
      assert_not_nil @avatar.name
    end
    start_full
    refute empty?
    assert full?
    assert_equal '', json['avatar_name']
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'5BD',
  'continue with id that exists but is empty' do
    create_kata
    continue
    assert empty?
    refute full?
  end

  #- - - - - - - - - - - - - - - -

  test prefix+'DEB',
  'continue with id that exists and is not empty' do
    create_kata
    start
    continue
    refute empty?
    refute full?
  end

  private

  def check_id
    params = { :format => :json, :id => @id }
    get 'enter/check', params
    assert_response :success
  end

  def empty?
    json['empty']
  end

  def full?
    json['full']
  end

end
