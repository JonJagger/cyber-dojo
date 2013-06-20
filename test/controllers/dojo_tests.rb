require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DojoControllerTest  < IntegrationTest

  test "index" do
    get 'dojo/index'
    assert_response :success
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
    Avatar.names.each do |avatar_name|      
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
  
  test "review_json with id that does not exist" do
    bad_id = 'ab00ab11ab'
    get 'dojo/review_json', {
      :format => :json,
      :id => bad_id
    }
    assert !json['exists']      
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -

  test "review_json with id that does exist" do
    id = checked_save_id
    get 'dojo/review_json', {
      :format => :json,
      :id => id
    }
    assert json['exists']      
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -
  
  test "button dialogs" do
    buttons = %w( about basics donations faqs feedback links source recruiting refactoring tips why )
    buttons.each do |name|
      get 'dojo/button_dialog', {
        :id => name
      }
      assert_response :success    
    end
  end
  
  # - - - - - - - - - - - - - - - - - - - - - -

  test "render 404 error" do
    get 'dojo/render_error', {
      :n => 404
    }
  end
  
end
