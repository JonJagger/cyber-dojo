#!/usr/bin/env ruby

require_relative 'integration_test_base'

class KataTests < IntegrationTestBase

  test 'exists? is false' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
  end

end
