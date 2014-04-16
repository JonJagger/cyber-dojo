require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DojoControllerTest  < IntegrationTest

  test "index" do
    get 'dojo/index'
    assert_response :success
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=false if no kata for id" do
    id = 'abcdef'
    get 'dojo/valid_id', {
      :format => :json,
      :id => id
    }
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=false if id.length < 6 and kata exists" do
    id = checked_save_id[0..4]
    assert id.length < 6
    get 'dojo/valid_id', {
      :format => :json,
      :id => id
    }
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=true if id.length == 6 and kata exists" do
    id = checked_save_id[0..5]
    assert id.length == 6
    get 'dojo/valid_id', {
      :format => :json,
      :id => id
    }
    assert json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=true if id.length > 6 and kata exists" do
    id = checked_save_id[0..6]
    assert id.length > 6
    get 'dojo/valid_id', {
      :format => :json,
      :id => id
    }
    assert json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "start_json with id that does not exist" do
    bad_id = 'ab00ab11ab'
    get 'dojo/start_json', {
      :format => :json,
      :id => bad_id
    }
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "start_json with id that does exist" do
    id = checked_save_id
    get 'dojo/start_json', {
      :format => :json,
      :id => id
    }
    assert json['exists']
    assert !json['full']
    assert_not_nil json['avatar_name']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "start-coding succeeds once for each avatar name, then dojo is full" do
    id = checked_save_id
    Avatars.names.each do |avatar_name|
      get '/dojo/start_json', {
        :format => :json,
        :id => id
      }
      assert json['exists']
      assert !json['full']
      assert_not_nil json['avatar_name']
    end

    get '/dojo/start_json', {
      :format => :json,
      :id => id
    }
    assert json['exists']
    assert json['full']
    assert_nil json['avatar_name']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "resume_json with id that does not exist" do
    bad_id = 'ab00ab11ab'
    get 'dojo/resume_json', {
      :format => :json,
      :id => bad_id
    }
    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "resume_json with id that exists but is empty" do
    id = checked_save_id
    get 'dojo/resume_json', {
      :format => :json,
      :id => id
    }
    assert json['exists']
    assert json['empty']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "resume_json with id that exists and is not empty" do
    id = checked_save_id
    get '/dojo/start_json', {
      :format => :json,
      :id => id
    }
    get 'dojo/resume_json', {
      :format => :json,
      :id => id
    }
    assert json['exists']
    assert !json['empty']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "button dialogs" do
    buttons = %w( about basics donators faqs feedback tips why )
    buttons.each do |name|
      get 'dojo/button_dialog', {
        :id => name
      }
      assert_response :success
    end
  end

end
