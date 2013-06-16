require File.dirname(__FILE__) + '/../test_helper'
require 'Files'

class FilesTests < ActionController::TestCase

  def setup
    id = 'ABCDE12345'
    @folder = "#{root_dir}/#{id}"
    system("mkdir #{@folder}")
  end
  
  def teardown
    system("rm -rf #{@folder}")
  end

  test "saving a file with a folder creates the subfolder and the file in it" do
    pathed_filename = 'f1/f2/wibble.txt'
    content = 'Hello world'
    full_pathed_filename = @folder + '/' + pathed_filename
    Files::file_write(full_pathed_filename, content)
    
    assert File.exists?(full_pathed_filename),
          "File.exists?(#{full_pathed_filename})"
    assert_equal content, IO.read(full_pathed_filename)          
  end

  test "save_file for non-string is saved as inspected object" do
    object = { :a => 1, :b => 2 }
    check_save_file('manifest.rb', object, "{:a=>1, :b=>2}\n", false)
  end
  
  test "save file for non executable file" do
    check_save_file('file.a', 'content', 'content', false)
  end
  
  test "save file for executable file" do
    check_save_file('file.sh', 'ls', 'ls', true)
  end
  
  test "save filename longer than but ends in makefile is not auto-tabbed" do
    content = '    abc'
    expected_content = content
    check_save_file('smakefile', content, expected_content, false)    
  end  
  
  test "save file for makefile converts all leading whitespace on a line to a single tab" do
    check_save_makefile("            abc", "\tabc")
    check_save_makefile("        abc", "\tabc")
    check_save_makefile("    abc", "\tabc")
    check_save_makefile("\tabc", "\tabc")
  end
  
  test "save file for Makefile converts all leading whitespace on a line to a single tab" do
    check_save_file('Makefile', "            abc", "\tabc", false)
    check_save_file('Makefile', "        abc", "\tabc", false)
    check_save_file('Makefile', "    abc", "\tabc", false)
    check_save_file('Makefile', "\tabc", "\tabc", false)
  end
  
  test "save file for makefile converts all leading whitespace to single tab for all lines in any line format" do
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
    pathed_filename = @folder + '/' + filename
    Files::file_write(pathed_filename, content)
    assert File.exists?(pathed_filename),
          "File.exists?(#{pathed_filename})"
    assert_equal expected_content, IO.read(pathed_filename)
    assert_equal executable, File.executable?(pathed_filename),
                            "File.executable?(pathed_filename)"
  end
  
end

