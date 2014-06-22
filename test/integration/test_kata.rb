#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'DummyTestRunner'

class KataTests < ActionController::TestCase
  include Externals

  def setup
    set_disk(OsDisk.new)
    set_git(Git.new)
    set_runner(DummyTestRunner.new)
    @dojo = Dojo.new(root_path,'json')
  end

  test "exists? is false for empty-string id" do
    kata = @dojo.katas[id='']
    assert !kata.exists?
  end

end
