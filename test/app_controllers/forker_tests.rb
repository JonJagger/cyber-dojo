require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class ForkerControllerTest < IntegrationTest

  test "fork" do
    id = checked_save_id

    get 'dojo/start_json', {
      :format => :json,            
      :id => id
    }
    avatar_name = json['avatar_name']    
    assert_not_nil avatar_name
    
    post 'kata/run_tests', {
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
    
    get "forker/fork", {
      :format => :json,      
      :id => id,
      :avatar => avatar_name,
      :tag => 1
    }
    assert_not_nil json['id']    
    assert_equal 10, json['id'].length
    assert_not_equal id, json['id']
    assert Kata.exists?(root_dir, json['id'])    
  end
  
end

