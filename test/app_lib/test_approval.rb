#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require 'tempfile'

class ApprovalTests < CyberDojoTestBase

=begin
  test 'readfile with no newline mapping' do
    temp_filename = Dir::Tmpname.create(['approval', '.txt']) {}
    File.open(temp_filename, 'w') do |file|
      file.write("line 1\n")
      file.write("line 2\n")
      file.write("line 3\n")
    end
    read = Approval.read_file(temp_filename)
    `rm #{temp_filename}`
    assert_equal "line 1\nline 2\nline 3\n", read
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'readfile with \r mapping' do
    temp_filename = Dir::Tmpname.create(['approval', '.txt']) {}
    File.open(temp_filename, 'w') do |file|
      file.write("line 1\r")
      file.write("line 2\r")
      file.write("line 3\r")
    end
    read = Approval.read_file(temp_filename)
    `rm #{temp_filename}`
    assert_equal "line 1\nline 2\nline 3\n", read
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'readfile with \r\n mapping' do
    temp_filename = Dir::Tmpname.create(['approval', '.txt']) {}
    File.open(temp_filename, 'w') do |file|
      file.write("line 1\r\n")
      file.write("line 2\r\n")
      file.write("line 3\r\n")
    end
    read = Approval.read_file(temp_filename)
    `rm #{temp_filename}`
    assert_equal "line 1\nline 2\nline 3\n", read
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'read non dot entries in dir' do
    temp_dir = Dir::Tmpname.create(['approval', '']) {}
    `mkdir #{temp_dir}`
    file_write(temp_dir + '/file1.txt')
    file_write(temp_dir + '/file2.txt')
    filenames = Approval.in(temp_dir).sort
    `rm -rf #{temp_dir}`
    assert_equal ['file1.txt','file2.txt'], filenames
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'remove deleted txt files' do
    temp_dir = Dir::Tmpname.create(['approval', '']) {}
    `mkdir #{temp_dir}`
    file_write(temp_dir + '/file1.txt')
    file_write(temp_dir + '/file2.rb')

    visible_files = {
      'file1.txt' => 'file1.txt:content',
      'file2.rb'  => 'file2.rb:content',
      'file3.txt' => 'file3.h:content'
    }
    Approval.remove_deleted_txt_files(temp_dir, visible_files)
    `rm -rf #{temp_dir}`
    expected = {
      'file1.txt' => 'file1.txt:content',
      'file2.rb'  => 'file2.rb:content',
    }
    assert_equal expected, visible_files
  end

  #- - - - - - - - - - - - - - - - - - - -

  test 'add created txt files' do
    temp_dir = Dir::Tmpname.create(['approval', '']) {}
    `mkdir #{temp_dir}`
    file_write(temp_dir + '/file1.txt')
    file_write(temp_dir + '/file2.rb')

    visible_files = { }
    Approval.add_created_txt_files(temp_dir, visible_files)
    `rm -rf #{temp_dir}`
    expected = {
      'file1.txt' => 'content',
    }
    assert_equal expected, visible_files
  end

  #- - - - - - - - - - - - - - - - - - - -

  def file_write(pathed_filename)
    File.open(pathed_filename, 'w') do |file|
      file.write('content')
    end
  end
=end

end
