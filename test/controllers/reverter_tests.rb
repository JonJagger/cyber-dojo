require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class ReverterControllerTest  < IntegrationTest

  test "revert" do
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

    get 'reverter/revert', { 
      :format => :json,
      :id => id,
      :avatar => avatar_name,
      :tag => 1
    }

    visible_files = json['visibleFiles']
    assert_not_nil visible_files
    assert_not_nil visible_files['output']
    
    inc = json['inc']
    assert_not_nil inc
    assert_equal "amber", inc['colour']
    assert_equal 1, inc['number']
  end
    
end
