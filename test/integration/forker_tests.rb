require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class ForkerControllerTest < IntegrationTest

  test "fork" do
    id = checked_save_id
    avatar_name = Avatar.names[0]
        
    post '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    
    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        quoted('cyber-dojo.sh') => ""
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

