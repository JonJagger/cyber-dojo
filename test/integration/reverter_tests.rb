require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class ReverterControllerTest  < IntegrationTest

  test "revert" do
    id = checked_save_id
    avatar = Avatar.names[0]
    
    post '/kata/edit', {
      :id => id,
      :avatar => avatar
    }
    
    post 'kata/run_tests', { # 1
      :id => id,
      :avatar => avatar,
      :file_content => { }
    }
    
    post 'kata/run_tests', { # 2
      :id => id,
      :avatar => avatar,
      :file_content => { }
    }

    #create kata_tests
    get 'reverter/revert', { 
      :format => :json,
      :id => id,
      :avatar => avatar,
      :tag => 1
    }

    visible_files = json['visibleFiles']
    assert_not_nil visible_files    
    expected = { "output" => "sh: ./cyber-dojo.sh: No such file or directory\n" }
    assert_equal expected, json['visibleFiles']
    
    inc = json['inc']
    assert_not_nil inc
    assert_equal "green", inc['colour']
    assert_equal 1, inc['number']
  end
    
end
