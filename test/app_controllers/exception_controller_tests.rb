require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class ExceptionControllerTests < IntegrationTest

  def setup
    @consider = Rails.application.config.consider_all_requests_local
    @show = Rails.application.config.action_dispatch.show_exceptions
    Rails.application.config.consider_all_requests_local = false
    Rails.application.config.action_dispatch.show_exceptions = true        
  end
  
  def teardown
    Rails.application.config.consider_all_requests_local = @consider
    Rails.application.config.action_dispatch.show_exceptions = @show      
  end
  
=begin
  test "404" do
    get 'dojo/sdsdsd'
    assert_template 'error/404'
  end
  
  test "500" do
    get 'kata/edit/234523424234'
    assert_template 'error/500'
  end
=end

end
