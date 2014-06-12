#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_dir'
require File.dirname(__FILE__) + '/spy_disk'

class SpyDiskTests < ActionController::TestCase

  test 'outer_dir is_dir? is true if inner_dir exists' do
    disk = SpyDisk.new
    outer_path = 'outer'
    inner_path = outer_path + '/' + 'inner'
    disk[inner_path + '/']
    assert disk.is_dir?(inner_path), "inner_path"
    assert disk.is_dir?(outer_path), "outer_path"
  end

end
