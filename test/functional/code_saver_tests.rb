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
  
  test "save_file_for_non_executable_file" do
    check_save_file('file.a', 'content', 'content', false)
  end
  
  test "save_file_for_executable_file" do
    check_save_file('file.sh', 'ls', 'ls', true)
  end
  
  test "save_file_for_makefile_converts_all_leading_whitespace_on_a_line_to_a_single_tab" do
    check_save_makefile("            abc", "\tabc")
    check_save_makefile("        abc", "\tabc")
    check_save_makefile("    abc", "\tabc")
    check_save_makefile("\tabc", "\tabc")
  end
  
  test "save_file_for_Makefile_converts_all_leading_whitespace_on_a_line_to_a_single_tab" do
    check_save_file('Makefile', "            abc", "\tabc", false)
    check_save_file('Makefile', "        abc", "\tabc", false)
    check_save_file('Makefile', "    abc", "\tabc", false)
    check_save_file('Makefile', "\tabc", "\tabc", false)
  end
  
  test "save_file_for_makefile_converts_all_leading_whitespace_to_single_tab_for_all_lines_on_any_line_format" do
    check_save_makefile("123\n456", "123\n456")
    check_save_makefile("123\r\n456", "123\n456")
    
    check_save_makefile("    123\n456", "\t123\n456")
    check_save_makefile("    123\r\n456", "\t123\n456")
    
    check_save_makefile("123\n    456", "123\n\t456")
    check_save_makefile("123\r\n    456", "123\n\t456")
    
    check_save_makefile("    123\n   456", "\t123\n\t456")
    check_save_makefile("    123\r\n   456", "\t123\n\t456")
    
    check_save_makefile("    123\n456\n   789", "\t123\n456\n\t789")    
    check_save_makefile("    123\r\n456\n   789", "\t123\n456\n\t789")    
    check_save_makefile("    123\n456\r\n   789", "\t123\n456\n\t789")    
    check_save_makefile("    123\r\n456\r\n   789", "\t123\n456\n\t789")    
  end
  
  def check_save_makefile(content, expected_content)
    check_save_file('makefile', content, expected_content, false)
  end
      
  def check_save_file(filename, content, expected_content, executable)
    CodeSaver::save_file(@sandbox_dir, filename, content)
    pathed_filename = @sandbox_dir + '/' + filename
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            "File.executable?(pathed_filename)"                      
  end
  
end

