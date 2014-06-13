#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/fake_dir'
require File.dirname(__FILE__) + '/fake_disk'

class FakeDirTests < ActionController::TestCase

  def setup
    @disk = FakeDisk.new
    @path = 'fake/'
    @dir = FakeDir.new(@disk,@path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "path is as set in ctor" do
    assert_equal @path, @dir.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false before make is called, true after" do
    assert !@dir.exists?
    @dir.make
    assert @dir.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "exists?(filename) is true after write(filename)" do
    filename = 'wibble.hpp'
    @dir.write(filename, '#include <iostream>')
    assert @dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "read(filename) raises if no file exists" do
    filename = 'wibble.rb'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "FakeDir['#{@path}'].read('#{filename}') no file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "read(filename) returns previous write(filename,content)" do
    filename = 'readme.txt'
    content = 'NB:important'
    @dir.write(filename, content)
    assert content, @dir.read(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "read(filename) raises if different filename stubbed" do
    @dir.write('wibble.h', '#include <stdio.h>')
    filename = 'wibble.cpp'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "FakeDir['#{@path}'].read('#{filename}') no file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test "each filters nested-sub-folders to immediate sub-folder only" do
    @disk[@path + 'a']
    @disk[@path + 'b']
    @disk[@path + 'b/c']
    assert_equal ['a','b'], @disk['fake'].entries.sort
    assert_equal ['a','b'], @disk['fake/'].entries.sort
  end

end
