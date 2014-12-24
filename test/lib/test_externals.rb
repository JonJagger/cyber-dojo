#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class ExternalsTests < CyberDojoTestBase

  include Externals

  def setup
    thread[:disk] = nil
    thread[:git] = nil
    thread[:runner] = nil
  end

  test 'raise_if_no(keys) raises on bad key' do
    assert_raises RuntimeError do
      raise_if_no([:bad])
    end
  end

  test 'raise_if_no(keys) raises if designated external not set' do
    assert_raises RuntimeError do
      raise_if_no([:disk])
    end
  end

  test 'accessing disk sets it to default' do
    disk
    raise_if_no([:disk])
  end

  test 'accessing git sets it to default' do
    git
    raise_if_no([:git])
  end

  test 'accessing runner sets it to default' do
    runner
    raise_if_no([:runner])
  end

  test 'when disk is set it is not overridden' do
    thread[:disk] = Object.new
    assert_equal 'Object', disk.class.name
  end

  test 'when git is set it is not overridden' do
    thread[:git] = Object.new
    assert_equal 'Object', git.class.name
  end

  test 'when runner is set it is not overridden' do
    thread[:runner] = Object.new
    assert_equal 'Object', runner.class.name
  end

  def path
    'fubar/'
  end

  test 'dir is disk[path]' do
    assert_equal path, dir.path
  end

end
