#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require 'tmpdir'
require 'pathname'

class ApprovalTests < CyberDojoTestBase

=begin
  def setup
    @temp_dir = Dir.mktmpdir
  end

  def teardown
    `rm -rf #{@temp_dir}`
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'non-txt file is not put into visible_files' do
    visible_files = { }
    File.open(Pathname.new(@temp_dir).join('foo.text'), 'w') { |file|
      file.write('foo updated')
    }
    Approval.add_created_txt_files(@temp_dir, visible_files)
    assert !visible_files.keys.include?('foo.text'), visible_files.to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'added txt file is put into visible_files' do
    visible_files = { }
    File.open(Pathname.new(@temp_dir).join('baz.txt'), 'w') { |file|
      file.write('baz updated')
    }
    Approval.add_created_txt_files(@temp_dir, visible_files)
    assert_match visible_files['baz.txt'], "baz updated", visible_files.to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'multiple added txt files are all put into visible files' do
    visible_files = { }
    File.open(Pathname.new(@temp_dir).join('baz.txt'), 'w') { |file|
      file.write('baz updated')
    }
    File.open(Pathname.new(@temp_dir).join('foo.txt'), 'w') { |file|
      file.write('foo updated')
    }
    Approval.add_created_txt_files(@temp_dir, visible_files)
    assert_match visible_files['baz.txt'], 'baz updated', visible_files.to_s
    assert_match visible_files['foo.txt'], 'foo updated', visible_files.to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'deleted txt files are removed from visible_files' do
    visible_files = { 'foo.txt' => 'foo', 'bar.txt' => 'bar' }
    File.open(Pathname.new(@temp_dir).join('bar.txt'), 'w') { |file|
      file.write('bar updated')
    }
    Approval.remove_deleted_txt_files(@temp_dir, visible_files)
    assert !visible_files.keys.include?('foo.txt'), visible_files.to_s
    assert  visible_files.keys.include?('bar.txt'), visible_files.to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'content from multi-line txt files is saved in visible_files' do
    visible_files = { }
    File.open(Pathname.new(@temp_dir).join('foo.txt'), 'w') { |file|
      file.write("a multiline\nstring\n")
    }
    Approval.add_created_txt_files(@temp_dir, visible_files)
    assert visible_files.keys.include?('foo.txt'), visible_files.to_s
    assert_match visible_files['foo.txt'], "a multiline\nstring\n", visible_files.to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'windows txt files are saved with unix line endings' do
    visible_files = { }
    File.open(Pathname.new(@temp_dir).join('bar.txt'), 'w') { |file|
      file.write("a multiline\r\nstring\r\n")
    }
    Approval.add_created_txt_files(@temp_dir, visible_files)
    assert_match visible_files['bar.txt'], "a multiline\nstring\n", visible_files.to_s
  end
=end

end
