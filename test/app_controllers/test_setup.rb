#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative 'integration_test'

class SetupControllerTest  < IntegrationTest

  test "show" do
    get 'setup/show'
    assert_response :success
  end

  test "save" do
    checked_save_id
  end

end
