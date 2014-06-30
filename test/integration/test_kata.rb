#!/usr/bin/env ruby

__DIR__ = File.dirname(__FILE__)
require __DIR__ + '/../test_helper'
require __DIR__ + '/externals'

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
