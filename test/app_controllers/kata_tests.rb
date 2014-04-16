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
        'cyber-dojo.sh' => ""
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }
    }

    post 'kata/run_tests', { # 2
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => ""
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }
    }
  end

  test "help dialog" do
    get "/kata/help_dialog", { :avatar_name => 'lion' }
    assert_response :success
  end
  
end
