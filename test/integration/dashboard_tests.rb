require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DashboardControllerTest < IntegrationTest

  test "show no avatars" do
    id = checked_save_id
    get "/dashboard/show", rooted({ :id => id })
    assert_response :success    
  end
    
  test "show avatars but no traffic-lights" do
    id = checked_save_id    
    (1..4).each do |n|
      post '/kata/edit', rooted({
        :id => id,
        :avatar => Avatar.names[n]
      })
    end
    get "dashboard/show", rooted({ :id => id })
    assert_response :success    
  end  
  
  test "show avatars with some traffic lights" do
    id = checked_save_id
    (1..3).each do |n|
      post '/kata/edit', rooted({
        :id => id,
        :avatar => Avatar.names[n]
      })
      (1..2).each do |m|
        post 'kata/run_tests', rooted(
          :id => id,
          :avatar => Avatar.names[n],
          :file_content => { }
        )        
      end
    end
    get "dashboard/show", rooted({ :id => id })
    assert_response :success        
  end
  
end

