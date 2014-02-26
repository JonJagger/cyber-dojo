require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_dir'

class SpyDirTests < ActionController::TestCase

  def setup
    @path = 'spied/'
    @dir = SpyDir.new(@path)
  end

  test "path is as set in ctor" do
    assert_equal @path, @dir.path
  end

  test "exists? is false before make is called, true after" do
    assert !@dir.exists?
    @dir.make
    assert @dir.exists?
  end

  test "exists?(filename) is false before spy_read(filename), true after" do
    @dir.make
    filename = 'wibble.h'
    assert !@dir.exists?(filename)
    @dir.spy_read(filename, '#include <stdio.h>')
    assert @dir.exists?(filename)
  end

  test "exists?(filename) is true after write(filename)" do
    filename = 'wibble.hpp'
    @dir.write(filename, '#include <iostream>')
    assert @dir.exists?(filename)
  end

  test "read(filename) returns previously write(filename,content)" do
    filename = 'readme.txt'
    content = 'NB:important'
    @dir.write(filename, content)
    assert content, @dir.read(filename)
  end

  test "read(filename) raises if no files stubbed" do
    filename = 'wibble.rb'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "SpyDir['#{@path}'].read('#{filename}') no files stubbed", error.message
  end

  test "read(filename) raises if different filename stubbed" do
    @dir.spy_read('wibble.h', '#include <stdio.h>')
    filename = 'wibble.cpp'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "SpyDir['#{@path}'].read('#{filename}') not stubbed", error.message
  end

  test "read(filename) returns stubbed content" do
    filename = 'film.txt'
    content = 'once upon a time in the west'
    @dir.spy_read(filename, content)
    assert_equal content, @dir.read(filename)
  end

  test "teardown when read_log and write_log both empty raises" do
    error = assert_raises(RuntimeError) { @dir.teardown }
    assert_equal "SpyDir['#{@path}'].read/write() never called", error.message
  end

  test "teardown when just read() does not raise" do
    filename = 'wibble.js'
    @dir.spy_read(filename, 'content')
    @dir.read(filename)
    @dir.teardown
  end

  test "teardown when just write() does not raise" do
    filename = 'wibble.js'
    @dir.write(filename, 'content')
    @dir.teardown
  end

=begin
  #test "spy_read(filename), read(filename), teardown does not raise" do
  #  filename = 'film.txt'
  #  @dir.spy_read(filename, 'the princess bride')
  #  @dir.read(filename)
  #  @dir.teardown
  #end

  test "spy_read(filename), no read(filename), teardown raises" do
    filename = 'great_film.txt'
    @dir.spy_read(filename, 'the princess bride')
    error = assert_raises(RuntimeError) { @dir.teardown }
    assert_equal "SpyDir['#{@path}'].no .read('#{filename}')", error.message
  end
=end


end
