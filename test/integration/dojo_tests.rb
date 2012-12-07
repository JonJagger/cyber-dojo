require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DojoControllerTest  < IntegrationTest

  test "index" do
    get 'dojo/index'
    assert_response :success
  end
  
  test "id does not exist" do
    bad_id = 'ab00ab11ab'
    get 'dojo/exists_json', {
        :format => :json,      
        :id => bad_id
    }
    assert_equal({"exists" => false}, json)
  end
  
  test "start_json with id that does not exist" do
    bad_id = 'ab00ab11ab'
    get 'dojo/start_json', {
      :format => :json,
      :id => bad_id
    }
    assert_equal false, json['exists']
  end
  
  test "start_json with id that does exist" do
    id = checked_save_id
    get 'dojo/start_json', {
      :format => :json,
      :id => id
    }
    assert_equal true , json['exists']
    assert_equal false, json['full']
    assert_not_nil json['avatar_name']
  end

  test "start-coding succeeds once for each avatar name, then dojo is full" do
    id = checked_save_id
    Avatar.names.each do |avatar_name|      
      get '/dojo/start_json', {
        :format => :json,
        :id => id
      }
      assert_equal true , json['exists']
      assert_equal false, json['full']
      assert_not_nil json['avatar_name']
    end

    get '/dojo/start_json', {
      :format => :json,
      :id => id
    }
    assert_equal true , json['exists']
    assert_equal true, json['full']
    assert_nil json['avatar_name']
  end

  test "resume avatar grid" do
    id = checked_save_id
    get '/dojo/start_json', {
      :format => :json,
      :id => id
    }
    post 'dojo/resume_avatar_grid', {
      :id => id
    }
  end
  
  test "full avatar grid" do
    id = checked_save_id
    post 'dojo/full_avatar_grid', {
      :id => id
    }                                                                                                                                                                                        
  end
  
end
