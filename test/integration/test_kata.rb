#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'externals'

class KataTests < CyberDojoTestBase

  include Externals

  def setup
    super
    @dojo = Dojo.new(root_path,externals(DummyTestRunner.new))
  end

  test 'exists? is false' do
    kata = @dojo.katas['123456789A']
    assert !kata.exists?
  end

end
