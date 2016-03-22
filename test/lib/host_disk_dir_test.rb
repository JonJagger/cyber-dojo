#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class HostDiskDirTest < LibTestBase

  def setup
    super
    assert_equal 'HostDisk', disk.class.name
    dir.make
  end

  def dir
    disk[path]
  end

  def path
    tmp_root + '/' + 'host_disk_dir_tests'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '76AEEB',
  'parent is set correctly' do
    assert_equal disk, disk['ABC'].parent
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '437EB1',
  'disk[...].path always ends in /' do
    assert_equal 'ABC/', disk['ABC'].path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '0DB5F3',
  'disk[path].make makes the directory' do
    `rm -rf #{path}`
    refute dir.exists?
    dir.make
    assert dir.exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '61FCE8',
  'disk[path].exists?(filename) false when file does not exist, true when it does' do
    refute dir.exists?(filename = 'hello.txt')
    dir.write(filename, 'content')
    assert dir.exists?(filename)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '247EAB',
  'disk[path].read() reads back what was written' do
    dir.write('filename', expected = 'content')
    assert_equal expected, dir.read('filename')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '1C4A9F',
    'write(filename, content) raises RuntimeError when content is not a string' do
    assert_raises(RuntimeError) { dir.write('any.txt', Object.new) }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '8F329F',
  'write(filename, content) succeeds when content is a string' do
    content = 'hello world'
    check_save_file('manifest.rb', content, content)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '2BAC6D',
  'write_json(filename, content) raises RuntimeError when filename does not end in .json' do
    assert_raises(RuntimeError) { dir.write_json('file.txt', 'any') }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3356EE',
  'read_json(filename) raises RuntimeError when filename does not end in .json' do
    assert_raises(RuntimeError) { dir.read_json('file.txt') }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F3B2F4',
  'write_json(filename, object) saves JSON.unparse(object) in filename' do
    dir.write_json(filename = 'object.json', { :a => 1, :b => 2 })
    json = dir.read(filename)
    object = JSON.parse(json)
    assert_equal 1, object['a']
    assert_equal 2, object['b']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '891336',
  'write_json_once succeeds once then its a no-op' do
    filename = 'once.json'
    refute dir.exists? filename
    dir.write_json_once(filename) { {:a=>1, :b=>2 } }
    assert dir.exists? filename
    object = dir.read_json(filename)
    assert_equal 1, object['a']
    assert_equal 2, object['b']
    dir.write_json_once(filename) { {:a=>3, :b=>4 } }
    object = dir.read_json(filename)
    assert_equal 1, object['a']
    assert_equal 2, object['b']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B9939D',
  'object = read_json(filename) after write_json(filename, object) round-strips ok' do
    dir.write_json(filename = 'object.json', { :a => 1, :b => 2 })
    object = dir.read_json(filename)
    assert_equal 1, object['a']
    assert_equal 2, object['b']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '95EA3F',
  'save file for non executable file' do
    check_save_file('file.a', 'content', 'content')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B5C931',
  'save file for executable file' do
    check_save_file('file.sh', 'ls', 'ls', executable = true)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '51EE30',
  'save filename ending in makefile is not auto-tabbed' do
    content = '    abc'
    expected_content = content # leading spaces not converted to tabs
    ends_in_makefile = 'smakefile'
    check_save_file(ends_in_makefile, content, expected_content)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '25EACA',
  'disk.dir?(.) is true' do
    assert disk.dir?(path + '/' + '.')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '75CA3F',
  'disk.dir?(..) is true' do
    assert disk.dir?(path + '/' + '..')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '73E40A',
  'disk.dir?(not-a-dir) is false' do
    refute disk.dir?('blah-blah')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'AFEE82',
  'disk.dir?(a-dir) is true' do
    assert disk.dir?(path)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '0CC3B9',
  'dir.each_dir' do
    cwd = `pwd`.strip + '/../'
    dirs = disk[cwd].each_dir.entries
    %w( app_helpers app_lib ).each { |dir_name| assert dirs.include?(dir_name), dir_name }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '91E408',
  'disk[path].each_dir does not give filenames' do
    disk[path].write('beta.txt', 'content')
    disk[path + '/' + 'alpha'].make
    disk[path + '/' + 'alpha'].write('a.txt', 'a')
    assert_equal ['alpha'], disk[path].each_dir.entries
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '89211C',
  'disk[path].each_dir.select' do
    disk[path + '/' + 'alpha'].make
    disk[path + '/' + 'beta' ].make
    disk[path + '/' + 'alpha'].write('a.txt', 'a')
    disk[path + '/' + 'beta' ].write('b.txt', 'b')
    matches = disk[path].each_dir.select { |dir| dir.start_with?('a') }
    assert_equal ['alpha'], matches.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '7CA54E',
  'disk[path].each_file' do
    disk[path + 'a'].make
    disk[path + 'a'].write('c.txt', 'content')
    disk[path + 'a'].write('d.txt', 'content')
    assert_equal ['c.txt','d.txt'], disk[path+'a'].each_file.entries.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '500EA2',
  'disk[path].each_file does not give dirs' do
    disk[path].make
    disk[path].write('beta.txt', 'content')
    disk[path + 'alpha'].make
    disk[path + 'alpha'].write('a.txt', 'a')
    assert_equal ['beta.txt'], disk[path].each_file.entries
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F569F8',
  'disk[path].each_file.select' do
    disk[path + 'a'].make
    disk[path + 'a'].write('b.cpp', 'content')
    disk[path + 'a'].write('c.txt', 'content')
    disk[path + 'a'].write('d.txt', 'content')
    matches = disk[path+'a'].each_file.select do |filename|
      filename.end_with?('.txt')
    end
    assert_equal ['c.txt','d.txt'], matches.sort
  end

  private

  def check_save_file(filename, content, expected_content, executable = false)
    dir.write(filename, content)
    pathed_filename = path + '/' + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            'File.executable?(pathed_filename)'
  end

end
