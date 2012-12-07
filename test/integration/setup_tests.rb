require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class SetupControllerTest  < IntegrationTest
  
  test "show" do
    get 'setup/show'
    assert_response :success
  end

  test "cancel" do
    post 'setup/cancel'
    assert_match @response.redirect_url, /^#{url_for :action => 'index', :controller => 'dojo'}/
  end

  test "save" do
    checked_save_id
  end
    
end
