require File.dirname(__FILE__) + '/../test_helper'
require 'integration_test'

class DashboardControllerTest < IntegrationTest

  test "show no avatars" do
    id = checked_save_id
    get "/dashboard/show", rooted({ :id => id })
    assert_response :success    
  end
  
  test "show avatars but no traffic-lights" do
    id = checked_save_id
    (1..4).each do |n|
      post '/dojo/start', rooted({ :id => id })
      avatar = avatar_from_response
      assert_redirected_to "/kata/edit?id=#{id}&avatar=#{avatar}"      
    end
    get "dashboard/show", rooted({ :id => id })
    assert_response :success    
  end  
  
  test "show avatars with some traffic lights" do
    id = checked_save_id
    (1..3).each do |n|
      post '/dojo/start', rooted({ :id => id })
      avatar = avatar_from_response
      assert_redirected_to "/kata/edit?id=#{id}&avatar=#{avatar}"
      (1..2).each do |m|
        post 'kata/run_tests', rooted(
          :id => id,
          :avatar => avatar,
          :file_content => { }
        )        
      end
    end
    get "dashboard/show", rooted({ :id => id })
    assert_response :success        
  end
  
end

