require File.dirname(__FILE__) + '/../test_helper'
require 'integration_test'

class DiffControllerTest < IntegrationTest

  test "show" do
    id = checked_save_id
    post 'dojo/start', rooted({ :id => id })
    avatar = avatar_from_response
    assert_redirected_to "/kata/edit?id=#{id}&avatar=#{avatar}"    
    post 'kata/run_tests', rooted(
      :id => id,
      :avatar => avatar,
      :file_content => { }
    )
    get "diff/show", rooted({
      :id => id,
      :avatar => avatar,
      :tag => 1
    })
    assert_response :success
  end
  
end

