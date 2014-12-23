#!/usr/bin/env ruby

require_relative 'model_test_base'

class DojoTests < ModelTestBase

  test 'path is as set' do
    assert_equal 'fake/', Dojo.new('fake/').path
  end

  test 'ctor raises if path does not end in /' do
    assert_raise RuntimeError do
      Dojo.new('fake')
    end
  end

end
