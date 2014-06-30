#!/usr/bin/env ruby

require_relative '../test_helper'
require_relative 'externals'

class KataTests < ActionController::TestCase

  include Externals

  def setup
    @dojo = Dojo.new(root_path,externals(DummyTestRunner.new))
  end

  test "exists? is false for empty-string id" do
    kata = @dojo.katas[id='']
    assert !kata.exists?
  end

end
