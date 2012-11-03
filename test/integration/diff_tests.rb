require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DiffControllerTest < IntegrationTest

  test "show" do
    id = checked_save_id
        
    post '/kata/edit', rooted({
      :id => id,
      :avatar => Avatar.names[0]
    })
    
    post 'kata/run_tests', rooted(
      :id => id,
      :avatar => Avatar.names[0],
      :file_content => { }
    )
    
    get "diff/show", rooted({
      :id => id,
      :avatar => Avatar.names[0],
      :tag => 1
    })
    assert_response :success
  end
  
end

