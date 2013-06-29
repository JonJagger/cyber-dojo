require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class KataControllerTest  < IntegrationTest

  test "edit and then run-tests" do
    id = checked_save_id
    
    get 'dojo/start_json', {
      :id => id
    }
    avatar_name = json['avatar_name']    
    
    post '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
       
    post 'kata/run_tests', { # 1
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        quoted('cyber-dojo.sh') => ""
      }
    }
    
    post 'kata/run_tests', { # 2
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        quoted('cyber-dojo.sh') => ""
      }
    }
  end
    
  test "help dialog" do
    get "/kata/help_dialog", { :avatar_name => 'lion' }
    assert_response :success            
  end
  
  test "fork dialog" do
    get "/kata/fork_dialog"
    assert_response :success            
  end
  
end
