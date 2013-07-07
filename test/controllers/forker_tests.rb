require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class ForkerControllerTest < IntegrationTest

  test "fork" do
    id = checked_save_id

    get 'dojo/start_json', {
      :id => id
    }
    avatar_name = json['avatar_name']    
        
    post '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    
    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        quoted('cyber-dojo.sh') => ""
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }      
    }
    
    get "diff/show", {
      :id => id,
      :avatar => avatar_name,
      :from_tag => 0,
      :to_tag => 1
    }
    
    get "forker/fork", {
      :id => id,
      :avatar => avatar_name,
      :tag => 1
    }

    assert_match @response.redirect_url, /^#{url_for :controller => 'dojo', :action => 'index'}/
    @response.redirect_url =~ /id=(.+)/ or fail "Unexpected #{@response.redirect_url}"    
  end
  
end

