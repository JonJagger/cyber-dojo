#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'DummyTestRunner'

class KataTests < ActionController::TestCase

  def setup
    disk   = OsDisk.new
    git    = Git.new
    runner = DummyTestRunner.new
    paas = Paas.new(disk, git, runner)
    @dojo = paas.create_dojo(root_path)
  end

  test "exists? is false for empty-string id" do
    kata = @dojo.katas[id='']
    assert !kata.exists?
  end

end

