#!/usr/bin/env ruby

require_relative 'model_test_base'

class DojoTests < ModelTestBase

  test 'path is as set' do
    assert_equal 'fake/', Dojo.new('fake/').path
  end

  test 'path always has trailing /' do
    assert_equal 'fake/', Dojo.new('fake').path
  end

end
