require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class KataControllerTest  < IntegrationTest

  test "edit and then run-tests" do
    id = checked_save_id
    avatar = Avatar.names[0]
    
    post '/kata/edit', {
      :id => id,
      :avatar => avatar
    }
    
    post 'kata/run_tests', { # 1
      :id => id,
      :avatar => avatar,
      :file_content => {
        'wibble.h' => [
          "#include WIBBLE_H",
          "...",
          "#endif"
        ].join("\n")
      }
    }
    
    post 'kata/run_tests', { # 2
      :id => id,
      :avatar => avatar,
      :file_content => { }
    }
  end
    
end
