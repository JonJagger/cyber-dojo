#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class ExternalsTests < CyberDojoTestBase

  include Externals

  def setup
    thread[:disk] = nil
    thread[:git] = nil
    thread[:runner] = nil
    thread[:exercises_path] = nil
    thread[:languages_path] = nil
    thread[:katas_path] = nil
  end

  test 'raises RuntimeError if disk not set' do
    assert_raises RuntimeError do
      disk
    end
  end

  test 'raises RuntimeError if git not set' do
    assert_raises RuntimeError do
      git
    end
  end

  test 'raises RuntimeError if runner not set' do
    assert_raises RuntimeError do
      runner
    end
  end

  test 'raises RuntimeError if exercises_path not set' do
    assert_raises RuntimeError do
      exercises_path
    end
  end

  test 'raises RuntimeError if languages_path not set' do
    assert_raises RuntimeError do
      languages_path
    end
  end

  test 'raises RuntimeError if katas_path not set' do
    assert_raises RuntimeError do
      katas_path
    end
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

  test 'dir is disk[path]' do
    thread[:disk] = DiskFake.new
    assert_equal path, dir.path
  end

  def path
    'fubar/'
  end

end
