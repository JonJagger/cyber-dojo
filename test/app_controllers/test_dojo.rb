#!/usr/bin/env ruby

require_relative 'controller_test_base'

class DojoControllerTest  < ControllerTestBase

  test 'index' do
    get 'dojo/index'
    assert_response :success
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=false when no kata for id' do
    id = 'abcdef'
    get 'dojo/check_id', :format => :json, :id => id
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=true when id.length < 6 and kata exists' do
    id = checked_save_id[0..4]
    assert id.length < 6
    get 'dojo/check_id', :format => :json, :id => id
    assert json['exists'], "json['exists']"
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=true when id.length == 6 and kata exists' do
    id = checked_save_id[0..5]
    assert id.length == 6
    get 'dojo/check_id', :format => :json, :id => id
    assert json['exists'], "json['exists']"
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'check_id exists=true when id.length > 6 and kata exists' do
    id = checked_save_id[0..6]
    assert id.length > 6
    get 'dojo/check_id', :format => :json, :id => id
    assert json['exists'], "json['exists']"
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with no id => !exists' do
    get 'dojo/enter', :format => :json
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with empty string id => !exists' do
    bad_id = ''
    get 'dojo/enter', :format => :json, :id => bad_id
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with id that does not exist => !exists' do
    bad_id = 'ab00ab11ab'
    get 'dojo/enter', :format => :json, :id => bad_id
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter with id that does exist => exists,!full,avatar_name' do
    id = checked_save_id
    get 'dojo/enter', :format => :json, :id => id
    assert json['exists']
    assert !json['full']
    assert_not_nil json['avatar_name']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 'enter succeeds once for each avatar name, then dojo is full' do
    id = checked_save_id
    Avatars.names.each do |avatar_name|
      get 'dojo/enter', :format => :json, :id => id
      assert json['exists']
      assert !json['full']
      assert_not_nil json['avatar_name']
    end
    get 'dojo/enter', :format => :json, :id => id
    assert json['exists']
    assert json['full']
    assert_nil json['avatar_name']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 're_enter with id that does not exist' do
    bad_id = 'ab00ab11ab'
    get 'dojo/re_enter', :format => :json, :id => bad_id
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 're_enter with id that exists but is empty' do
    id = checked_save_id
    get 'dojo/re_enter', :format => :json, :id => id
    assert json['exists']
    assert json['empty']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test 're_enter with id that exists and is not empty' do
    id = checked_save_id
    get 'dojo/enter', :format => :json, :id => id
    get 'dojo/re_enter', :format => :json, :id => id
    assert json['exists']
    assert !json['empty']
  end

end
