#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'

class HostDiskTests < LibTestBase

  def setup
    super
    `rm -rf #{path}`
    `mkdir -p #{path}`
  end

  def disk
    @disk ||= HostDisk.new
  end
  
  def path
    File.expand_path('../..', File.dirname(__FILE__)) + '/tmp/'
  end
  
  def dir
    disk[path]
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[...].path always ends in /' do
    assert_equal "ABC/", disk['ABC'].path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].exists? false when path does not exist, true when it does' do
    `rm -rf #{path}`
    assert !dir.exists?
    dir.make
    assert dir.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].exists?(filename) false when file exists, true when it does' do
    `rm -rf #{path}`
    filename = 'hello.txt'
    assert !dir.exists?(filename)
    dir.write(filename, "content")
    assert dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].read() reads back what was written' do
    expected = "content"
    dir.write('filename', expected)
    actual = dir.read('filename')
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk.lock throws exception, does not execute block, ' +
       'and result is nil, when path does not exist' do
    block_run = false
    exception_thrown = false
    begin
      result = disk.lock('path_does_not_exist') do
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

  test 'when dir.lock is obtained block is executed ' +
       'and result is result of block' do
    block_run = false
    begin
      result = dir.lock {
        block_run = true; 'Hello'
      }
      assert block_run, 'block_run'
      assert_equal 'Hello', result
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'outer dir.lock is blocking so inner lock blocks' do
    outer_run = false
    inner_run = false
    dir.lock do
      outer_run = true

      inner_thread = Thread.new {
        dir.lock do
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
    parent_path = path + 'parent' + disk.dir_separator
    child_path = parent_path + 'child' + disk.dir_separator
    `mkdir #{parent_path}`
    `mkdir #{child_path}`
    parent_run = false
    child_run = false
    disk[parent_path].lock do
      parent_run = true
      disk[child_path].lock do
        child_run = true
      end
    end
    assert parent_run
    assert child_run
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'symlink' do
    expected = 'content'
    dir.write('filename', expected)
    oldname = path + 'filename'
    newname = path + 'linked'
    disk.symlink(oldname, newname)
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
    dir.write(pathed_filename, content)
    full_pathed_filename = path + pathed_filename
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

  test 'disk.dir?(.) is true' do
    assert disk.dir?(path + '.')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk.dir?(..) is true' do
    assert disk.dir?(path + '..')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk.dir?(not-a-dir) is false' do
    assert !disk.dir?('blah-blah')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk.dir?(a-dir) is true' do
    assert disk.dir?(path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'dir.each_dir' do
    cwd = `pwd`.strip + '/../'
    dirs = disk[cwd].each_dir.entries
    %w( app_helpers app_lib ).each { |dir_name|
      assert dirs.include?(dir_name), dir_name
    }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].each_dir does not give filenames' do
    disk[path].make
    disk[path].write('beta.txt', 'content')
    disk[path + 'alpha'].make
    disk[path + 'alpha'].write('a.txt', 'a')
    assert_equal ['alpha'], disk[path].each_dir.entries
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].each_dir.select' do
    disk[path + 'alpha'].make
    disk[path + 'beta'].make
    disk[path + 'alpha'].write('a.txt', 'a')
    disk[path + 'beta'].write('b.txt', 'b')
    matches = disk[path].each_dir.select { |dir|
      dir.start_with?('a')
    }
    assert_equal ['alpha'], matches.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].each_file' do
    disk[path + 'a'].write('c.txt', 'content')
    disk[path + 'a'].write('d.txt', 'content')
    assert_equal ['c.txt','d.txt'], disk[path+'a'].each_file.entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].each_file does not give dirs' do
    disk[path].make
    disk[path].write('beta.txt', 'content')
    disk[path + 'alpha'].make
    disk[path + 'alpha'].write('a.txt', 'a')
    assert_equal ['beta.txt'], disk[path].each_file.entries
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'disk[path].each_file.select' do
    disk[path + 'a'].write('b.cpp', 'content')
    disk[path + 'a'].write('c.txt', 'content')
    disk[path + 'a'].write('d.txt', 'content')
    matches = disk[path+'a'].each_file.select {|filename|
      filename.end_with?('.txt')
    }
    assert_equal ['c.txt','d.txt'], matches.sort
  end
  
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # complete_kata_id
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'complete(id=nil) is ""' do
    assert_equal "", dir.complete_kata_id(nil)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id="") is ""' do
    assert_equal '', dir.complete_kata_id('')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id): id unchanged when id is less than 4 chars in length ' +
       'because trying to complete from a short id will waste time going through ' +
       'lots of candidates with the likely outcome of no unique result' do
    id = unique_id[0..2]
    assert_equal 3, id.length
    assert_equal id, dir.complete_kata_id(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id): id unchanged when 4+ chars long and no matches' do
    id = unique_id[0..3]
    assert_equal 4, id.length
    assert_equal id, dir.complete_kata_id(id)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'complete(id) does complete when 4+ chars and 1 match' do
    id = unique_id
    make_dir_with_split_id(id)
    assert_equal id, disk[path].complete_kata_id(id[0..3])
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'complete(id): id unchanged when 4+ chars long and 2+ matches' do
    id = unique_id     
    common = path + split(id[0..3])                        
    match_1 = common + unique_id[4..-1]
    match_2 = common + unique_id[4..-1]
    assert_not_equal match_1,match_2
    disk[match_1].make   # .../temp/45/6E94442D
    disk[match_2].make   # .../temp/45/6E7433ED
    assert_equal id[0..3], disk[path].complete_kata_id(id[0..3])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # each kata id 
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test 'each_kata_id yields nothing when there are no katas' do
    assert_equal [], dir.each_kata_id.entries
  end

  test 'each_kata_id yields the kata id when there is one kata' do
    id = unique_id
    make_dir_with_split_id(id)    
    assert_equal [id], dir.each_kata_id.entries
  end

  test 'each_kata_id yields the katas ids when there are many katas' do
    ids = [ ]
    10.times do 
      id = unique_id
      ids << id 
      make_dir_with_split_id(id)          
    end      
    assert_equal ids.sort, dir.each_kata_id.entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check_save_file(filename, content, expected_content, executable = false)
    dir.write(filename, content)
    pathed_filename = path + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            'File.executable?(pathed_filename)'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def split(id)
    id[0..1] + '/' + id[2..-1]
  end

  def make_dir_with_split_id(id)
    disk[path + split(id)].make
  end
  
end
