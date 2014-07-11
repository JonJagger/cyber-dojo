#!/usr/bin/env ruby

require_relative 'controller_test_base'

class LocalesControllerTest  < ControllerTestBase

  test 'change locale' do

    get '/locales/change', {
      :id => 'ABCDE12345'
    }, {
      'HTTP_REFERER' => 'http://cyber-dojo.com'
    }
    assert_equal 302, response.status
  end

end
