require File.dirname(__FILE__) + '/../test_helper'
require 'CodeSaver'

# > ruby test/functional/code_saver_tests.rb

class CodeSaverTests < ActionController::TestCase
      
  def setup
    temp_dir = `uuidgen`.strip.delete('-')[0..9]
    @sandbox_dir = RAILS_ROOT + '/test/cyberdojo/code_runner/' + temp_dir
    Dir.mkdir @sandbox_dir
  end
  
  def teardown
    `rm -rf #{@sandbox_dir}`
    @sandbox_dir = nil
  end
  
  def test_save_file_combinations
    check_save_file('file.a', 'content', false, 'content')
    check_save_file('file.sh', 'ls', true, 'ls')
    check_save_file('makefile', '        abc', false, "\tabc")
    check_save_file('makefile', '    abc', false, "\tabc")
    check_save_file('makefile', "\tabc", false, "\tabc")
    check_save_file('Makefile', '        abc', false, "\tabc")
    check_save_file('Makefile', '    abc', false, "\tabc")
    check_save_file('Makefile', "\tabc", false, "\tabc")
  end
  
  def check_save_file(filename, content, executable, expected_content)
    CodeSaver::save_file(@sandbox_dir, filename, content)
    pathed_filename = @sandbox_dir + '/' + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            "File.executable?(pathed_filename)"                      
  end
  
end

