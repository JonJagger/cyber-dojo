require_relative '../test_helper'
require_relative 'integration_test'

class LocalesControllerTest  < IntegrationTest

  test "change locale" do
    get "/locales/change", {
      :id => 'ABCDE12345'
    }, {
      'HTTP_REFERER' => 'http://cyber-dojo.com'
    }
    assert_equal 302, response.status
  end


end
