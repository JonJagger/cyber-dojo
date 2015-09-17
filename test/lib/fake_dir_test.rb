#!/bin/bash ../test_wrapper.sh

require_relative 'LibTestBase'

class FakeDirTests < LibTestBase

  def setup
    super
    @disk = DiskFake.new
    @path = 'fake/'
    @dir = DirFake.new(@disk,@path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '3DFFB4',
  'path is as set in ctor' do
    assert_equal @path, @dir.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '7EAB97',
  'exists? is false before make is called, true after' do
    assert !@dir.exists?
    @dir.make
    assert @dir.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '02667B',
  'exists?(filename) is true after write(filename)' do
    filename = 'wibble.hpp'
    @dir.write(filename, '#include <iostream>')
    assert @dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '80386D',
  'after delete(filename) exists?(filename) is false' do
    filename = 'wibble.hpp'
    @dir.write(filename, '#include <iostream>')
    assert @dir.exists?(filename)
    @dir.delete(filename)
    assert !@dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '23A00D',
  'read(filename) raises if no file exists' do
    filename = 'wibble.rb'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "DirFake['#{@path}'].read('#{filename}') no file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '7C2BC9',
  'read(filename) returns previous write(filename,content)' do
    filename = 'fable.txt'
    content = 'once upon a time'
    @dir.write(filename, content)
    assert content, @dir.read(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'AC06A5',
  'read(filename) raises if different filename stubbed' do
    @dir.write('wibble.h', '#include <stdio.h>')
    filename = 'wibble.cpp'
    error = assert_raises(RuntimeError) { @dir.read(filename) }
    assert_equal "DirFake['#{@path}'].read('#{filename}') no file", error.message
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '5990F3',
  'each_dir filters nested-sub-folders to immediate sub-folder only' do
    @disk[@path + 'a']
    @disk[@path + 'b']
    @disk[@path + 'b/c']
    assert_equal ['a','b'], @disk['fake'].each_dir.entries.sort
    assert_equal ['a','b'], @disk['fake/'].each_dir.entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'FB696A',
  'each_file' do
    @disk[@path + 'a'].write('c.txt', 'content')
    @disk[@path + 'a'].write('d.txt', 'content')
    assert_equal ['c.txt','d.txt'], @disk[@path+'a'].each_file.entries.sort
    assert_equal ['c.txt','d.txt'], @disk[@path+'a/'].each_file.entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'B1277C',
  'each_file.select' do
    @disk[@path + 'a'].write('b.cpp', 'content')
    @disk[@path + 'a'].write('c.txt', 'content')
    @disk[@path + 'a'].write('d.txt', 'content')
    matches = @disk[@path + 'a'].each_file.select { |filename|
      filename.end_with?('.txt')
    }
    assert_equal ['c.txt','d.txt'], matches.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'D7B4B9',
  'write() raises if filename ends in .rb and content is string' do
    assert_raises RuntimeError do
      @dir.write('filename.rb', 'theory')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '1A7080',
  'write(filename.rb,content) succeeds and can be read back as ruby object' do
    @dir.write('filename.rb', { :answer => 42 })
    assert_equal '{:answer=>42}', @dir.read('filename.rb')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '69956C',
  'write() raises if filename ends in .json and content is string' do
    assert_raises RuntimeError do
      @dir.write('filename.json', 'theory')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'A52C14',
  'write(filename.json,content) succeeds and can be read back as json object' do
    @dir.write('filename.json', { :answer => 42 })
    assert_equal '{"answer":42}', @dir.read('filename.json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test 'E62D99',
  'write(filename.txt,content) succeeds and can be read back' do
    @dir.write('filename.txt','hello, world')
    assert_equal 'hello, world', @dir.read('filename.txt')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '613B86',
  'Dir.each_dir.select' do
    @disk[@path + 'alpha'].make
    @disk[@path + 'alpha'].write('a.txt', 'a')
    @disk[@path + 'beta'].make
    @disk[@path + 'beta'].write('b.txt', 'b')
    matches = @disk[@path].each_dir.select { |dir|
      dir.start_with?('a')
    }
    assert_equal ['alpha'], matches.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - -

  test '0C3F12',
  'lock(block) is executed' do
    called = false
    @dir.lock do
      called = true
    end
    assert called
  end

end
