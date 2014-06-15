#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'DummyTestRunner'

class KataTests < ActionController::TestCase

  def setup
    thread = Thread.current
    thread[:disk]   = OsDisk.new
    thread[:git]    = Git.new
    thread[:runner] = DummyTestRunner.new
    @dojo = Dojo.new(root_path)
  end

  test "exists? is false for empty-string id" do
    kata = @dojo.katas[id='']
    assert !kata.exists?
  end

end

