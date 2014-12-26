#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class SpyDiskTests < CyberDojoTestBase

  test 'each() filters nested sub-folders to the immediate sub-folder only' do
    path = 'spied/'
    disk = SpyDisk.new
    disk[path + 'a']
    disk[path + 'b']
    disk[path + 'b/c']
    assert_equal [['a','spied/a'],['b','spied/b']], disk['spied'].entries.sort
    assert_equal [['a','spied/a'],['b','spied/b']], disk['spied/'].entries.sort
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
       'when outer/inner/ dir exists (note extra slash)' do
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

  #- - - - - - - - - - - - - - - - - - - -

  test "symlinks appear in symlink log" do
    disk = SpyDisk.new
    disk.symlink('from','to')
    assert_equal [['symlink','from','to']], disk.symlink_log
  end

end
