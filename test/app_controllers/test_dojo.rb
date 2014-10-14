#!/usr/bin/env ruby

require_relative 'controller_test_base'

class DojoControllerTest  < ControllerTestBase

  test 'index without id' do
    get 'dojo/index'
    assert_response :success
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'index with id' do
    get 'dojo/index', :id => '1234512345'
    assert_response :success
    # enter is enabled
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=false when no kata for id' do
    @id = 'abcdef'
    check_id
    assert !exists?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=true when id.length < 6 and kata exists' do
    @id = checked_save_id[0..4]
    assert @id.length < 6
    check_id
    assert exists?
    assert !empty?
    assert !full?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=true when id.length == 6 and kata exists' do
    @id = checked_save_id[0..5]
    assert @id.length == 6
    check_id
    assert exists?
    assert !empty?
    assert !full?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=true when id.length > 6 and kata exists' do
    @id = checked_save_id[0..6]
    assert @id.length > 6
    check_id
    assert exists?
    assert !empty?
    assert !full?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with no id => !exists' do
    enter
    assert !exists?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with empty string id => !exists' do
    @id = ''
    enter
    assert !exists?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with id that does not exist => !exists' do
    @id = 'ab00ab11ab'
    enter
    assert !exists?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with id that does exist => exists,!full,avatar_name' do
    @id = checked_save_id
    enter
    assert exists?
    assert !empty?
    assert !full?
    assert_not_nil avatar_name
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter succeeds once for each avatar name, then dojo is full' do
    @id = checked_save_id
    Avatars.names.each do |avatar_name|
      enter
      assert exists?
      assert !full?
      assert_not_nil avatar_name
    end
    enter
    assert exists?
    assert !empty?
    assert full?
    assert_nil avatar_name
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 're_enter with id that does not exist' do
    @id = 'ab00ab11ab'
    re_enter
    assert !exists?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 're_enter with id that exists but is empty' do
    @id = checked_save_id
    re_enter
    assert exists?
    assert empty?
    assert !full?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 're_enter with id that exists and is not empty' do
    @id = checked_save_id
    enter
    re_enter
    assert exists?
    assert !empty?
    assert !full?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def check_id
    get 'dojo/check_id', :format => :json, :id => @id
  end

  def enter
    if !@id.nil?
      get 'dojo/enter', :format => :json, :id => @id
    else
      get 'dojo/enter', :format => :json
    end
  end

  def re_enter
    get 'dojo/re_enter', :format => :json, :id => @id
  end

  def exists?
    json['exists']
  end

  def empty?
    json['empty']
  end

  def full?
    json['full']
  end

  def avatar_name
    json['avatar_name']
  end

end
