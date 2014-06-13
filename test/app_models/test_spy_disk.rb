#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_dir'
require File.dirname(__FILE__) + '/spy_disk'

class SpyDiskTests < ActionController::TestCase

  test 'each() filters nested sub-folders to the immediate sub-folder only' do
    disk = SpyDisk.new
    path = 'spied/'
    disk[path + 'a']
    disk[path + 'b']
    disk[path + 'b/c']
    assert_equal ['a','b'], disk['spied'].each.entries.sort
    assert_equal ['a','b'], disk['spied/'].each.entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'outer is_dir? is true and outer/ is_dir? is true ' +
       'when outer/inner dir exists ' do
    outer_path = 'outer'
    inner_path = outer_path + '/' + 'inner'
    disk = SpyDisk.new
    disk[inner_path + '/']
    assert disk.is_dir?(inner_path), "inner_path"
    assert disk.is_dir?(outer_path), "outer_path"
    assert disk.is_dir?(outer_path + '/'), "outer_path/"
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'outer is_dir? is true and outer/ is_dir? is true ' +
       'when outer/inner/ dir exists ' do
    outer_path = 'outer'
    inner_path = outer_path + '/' + 'inner'
    disk = SpyDisk.new
    disk[inner_path]
    assert disk.is_dir?(inner_path), "inner_path"
    assert disk.is_dir?(outer_path), "outer_path"
    assert disk.is_dir?(outer_path + '/'), "outer_path/"
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'only complete directories exist' do
    inner_path = 'outer/inner'
    disk = SpyDisk.new
    disk[inner_path]
    incomplete_path = inner_path[0..-2]
    assert !disk.is_dir?(incomplete_path), incomplete_path
  end

end
