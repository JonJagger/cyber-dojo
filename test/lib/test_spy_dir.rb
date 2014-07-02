#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'

class SpyDirTests < CyberDojoTestBase

  def setup
    @disk = SpyDisk.new
    @path = 'spied/'
    @dir = SpyDir.new(@disk,@path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path is as set in ctor' do
    assert_equal @path, @dir.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is false before make is called, true after' do
    assert !@dir.exists?
    @dir.make
    assert @dir.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists?(filename) is true after spy_read(filename)' do
    @dir.make
    filename = 'wibble.h'
    assert !@dir.exists?(filename)
    @dir.spy_read(filename, '#include <stdio.h>')
    assert @dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists?(filename) is true after write(filename)' do
    filename = 'wibble.hpp'
    @dir.write(filename, '#include <iostream>')
    assert @dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists?(filename) is false after spy_write(filename)' do
    filename = 'wibble.hpp'
    @dir.spy_write(filename, '#include <iostream>')
    assert !@dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'read(filename) returns previous write(filename,content)' do
    filename = 'fable.txt'
    content = 'once upon a time'
    @dir.write(filename, content)
    assert content, @dir.read(filename)
    content = 'er no its not'
    @dir.write(filename, content)
    assert content, @dir.read(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'read(filename) raises when no files stubbed or written' do
    filename = 'wibble.rb'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "SpyDir['#{@path}'].read('#{filename}') no stub file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'read(filename) raises when different filename stubbed' do
    @dir.spy_read('wibble.h', '#include <stdio.h>')
    filename = 'wibble.cpp'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "SpyDir['#{@path}'].read('#{filename}') no stub file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'read(filename) returns content setup in corresponding spy_read()' do
    filename = 'the_princess_bride.txt'
    content = 'I am not left handed'
    @dir.spy_read(filename, content)
    assert_equal content, @dir.read(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'teardown when no spying ' +
       'and no read()s ' +
       'and no write()s does not raise' do
    @dir.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'teardown when no spying ' +
       'and some write()s does not raise' do
    filename = 'wibble.js'
    @dir.write(filename, 'content')
    @dir.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when all spy_read(filename) calls have corresponding ' +
       'read(filename) calls, then teardown does not raise' do
    filename = 'the_princess_bride.txt'
    @dir.spy_read(filename, 'cough cough cough')
    @dir.read(filename)
    @dir.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when any spy_read(filename) call has no corresponding ' +
       'read(filename) call then teardown raises' do
    filename = 'princess_bride.txt'
    content = 'inconceivable'
    @dir.spy_read(filename, content)
    error = assert_raises(RuntimeError) { @dir.teardown }
    expected = ['read',filename,content]
    assert_equal "SpyDir['#{@path}'].teardown() log.include?(#{expected})", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when all spy_write(filename,content) calls have corresponding ' +
       'write(filename,content) calls, then teardown does not raise' do
    filename = 'the_princess_bride.txt'
    content = "nonsense, you're just saying that because no-one ever has"
    @dir.spy_write(filename, content)
    @dir.write(filename, content)
    @dir.teardown
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when any spy_write(filename,content) calls has no corresponding ' +
       'write(filename,content) call then teardown raises RuntimeError' do
    filename = 'the_princess_bride.txt'
    content = 'are you miracle max?'
    @dir.spy_write(filename, content)
    @dir.write(filename+'X', content)
    @dir.write(filename, content+'X')
    error = assert_raise(RuntimeError) { @dir.teardown }
    expected = ['write',filename,content]
    assert_equal "SpyDir['#{@path}'].teardown() log.include?(#{expected})", error.message
  end

end
