#!/usr/bin/env ruby

require_relative 'lib_test_base'

class DiskTests < LibTestBase

  def setup
    @disk = Disk.new
    @dir = root_path + 'tmp/'
    `rm -rf #{@dir}`
    `mkdir -p #{@dir}`
  end

  def root_path
    File.expand_path('../..', File.dirname(__FILE__)) + '/'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '[dir] always has path ending in /' do
    assert_equal "ABC/", @disk['ABC'].path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists?(dir) false when dir does not exist, true when it does' do
    `rm -rf #{@dir}`
    assert !@disk[@dir].exists?
    @disk[@dir].make
    assert @disk[@dir].exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists?(filename) false when file exists, true when it does' do
    `rm -rf #{@dir}`
    filename = 'hello.txt'
    assert !@disk[@dir].exists?(filename)
    @disk[@dir].write(filename, "content")
    assert @disk[@dir].exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'reads back what was written' do
    expected = "content"
    @disk[@dir].write('filename', expected)
    actual = @disk[@dir].read('filename')
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'on lock if path does not exist exception is thrown, ' +
       'block is not_executed, ' +
       'and result is nil' do
    block_run = false
    exception_thrown = false
    begin
      result = @disk.lock('dir_does_not_exist') do
        block_run = true
      end
    rescue
      exception_thrown = true
    end

    assert exception_thrown
    assert !block_run
    assert_nil result
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'if lock is obtained block is executed ' +
       'and result is result of block' do
    block_run = false
    begin
      result = @disk[@dir].lock {
        block_run = true; 'Hello'
      }
      assert block_run, 'block_run'
      assert_equal 'Hello', result
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'outer lock is blocking so inner lock blocks' do
    outer_run = false
    inner_run = false
    @disk[@dir].lock do
      outer_run = true

      inner_thread = Thread.new {
        @disk[@dir].lock do
          inner_run = true
        end
      }
      max_seconds = 2
      inner_thread.join(max_seconds);
      if !inner_thread.nil?
        Thread.kill(inner_thread)
      end
    end
    assert outer_run
    assert !inner_run
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'holding lock on parent dir does not prevent ' +
       'acquisition of lock on child dir' do
    parent_dir = @dir + 'parent' + @disk.dir_separator
    child_dir = parent_dir + 'child' + @disk.dir_separator
    `mkdir #{parent_dir}`
    `mkdir #{child_dir}`
    parent_run = false
    child_run = false
    @disk[parent_dir].lock do
      parent_run = true
      @disk[child_dir].lock do
        child_run = true
      end
    end
    assert parent_run
    assert child_run
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'symlink' do
    expected = 'content'
    @disk[@dir].write('filename', expected)
    oldname = @dir + 'filename'
    newname = @dir + 'linked'
    @disk.symlink(oldname, newname)
    assert !File.symlink?(oldname)
    assert File.symlink?(newname)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save_file (json) for non-string is saved as JSON object ' +
       'and folder is automatically created' do
    object = { :a => 1, :b => 2 }
    check_save_file('manifest.json', object, '{"a":1,"b":2}')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save_file for string - folder is automatically created' do
    object = 'hello world'
    check_save_file('manifest.rb', object, "hello world")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'saving a file with a folder creates the subfolder ' +
       'and the file in it' do
    pathed_filename = 'f1/f2/wibble.txt'
    content = 'Hello world'
    @disk[@dir].write(pathed_filename, content)

    full_pathed_filename = @dir + pathed_filename
    assert File.exists?(full_pathed_filename),
          "File.exists?(#{full_pathed_filename})"
    assert_equal content, IO.read(full_pathed_filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save file for non executable file' do
    check_save_file('file.a', 'content', 'content')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save file for executable file' do
    executable = true
    check_save_file('file.sh', 'ls', 'ls', executable)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'save filename longer than but ends in makefile is not auto-tabbed' do
    content = '    abc'
    expected_content = content
    check_save_file('smakefile', content, expected_content)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir?(.) is true' do
    assert @disk.dir?(@dir + '.')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir?(..) is true' do
    assert @disk.dir?(@dir + '..')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir?(not-a-dir) is false' do
    assert !@disk.dir?('blah-blah')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir?(a-dir) is true' do
    assert @disk.dir?(@dir)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'Dir.each_dir' do
    cwd = `pwd`.strip + '/../'
    dirs = @disk[cwd].each_dir.entries
    %w( app_helpers app_lib ).each { |dir_name|
      assert dirs.include?(dir_name), dir_name
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'Dir.each_dir does not give filenames' do
    @disk[@dir].make
    @disk[@dir].write('beta.txt', 'content')
    @disk[@dir + 'alpha'].make
    @disk[@dir + 'alpha'].write('a.txt', 'a')
    assert_equal ['alpha'], @disk[@dir].each_dir.entries
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'Dir.each_dir.select' do
    @disk[@dir + 'alpha'].make
    @disk[@dir + 'beta'].make
    @disk[@dir + 'alpha'].write('a.txt', 'a')
    @disk[@dir + 'beta'].write('b.txt', 'b')
    matches = @disk[@dir].each_dir.select { |dir|
      dir.start_with?('a')
    }
    assert_equal ['alpha'], matches.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'Dir.each_file' do
    @disk[@dir + 'a'].write('c.txt', 'content')
    @disk[@dir + 'a'].write('d.txt', 'content')
    assert_equal ['c.txt','d.txt'], @disk[@dir+'a'].each_file.entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'Dir.each_file does not give dirs' do
    @disk[@dir].make
    @disk[@dir].write('beta.txt', 'content')
    @disk[@dir + 'alpha'].make
    @disk[@dir + 'alpha'].write('a.txt', 'a')
    assert_equal ['beta.txt'], @disk[@dir].each_file.entries
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'Dir.each_file.select' do
    @disk[@dir + 'a'].write('b.cpp', 'content')
    @disk[@dir + 'a'].write('c.txt', 'content')
    @disk[@dir + 'a'].write('d.txt', 'content')
    matches = @disk[@dir+'a'].each_file.select {|filename|
      filename.end_with?('.txt')
    }
    assert_equal ['c.txt','d.txt'], matches.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check_save_file(filename, content, expected_content, executable = false)
    @disk[@dir].write(filename, content)
    pathed_filename = @dir + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            'File.executable?(pathed_filename)'
  end

end
