require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class KataControllerTest  < IntegrationTest

  test "edit and then run-tests" do
    id = checked_save_id
    avatar_name = Avatar.names[0]
    
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
    
end
