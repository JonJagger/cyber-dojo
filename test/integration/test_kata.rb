#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'externals'

class KataTests < CyberDojoTestBase

  include Externals

  def setup
    @dojo = Dojo.new(root_path,externals(DummyTestRunner.new))
  end

  test 'exists? is false for empty-string id' do
    kata = @dojo.katas[id='']
    assert !kata.exists?
  end

end
