require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/mock_disk_file'

class LanguageTests < ActionController::TestCase

  def setup
    @mock_file = MockDiskFile.new
    Thread.current[:file] = @mock_file
    @language = Language.new(root_dir, 'Ruby-installed-and-working')
  end
  
  def teardown
    Thread.current[:file] = nil
  end
  
  test "name is as set in ctor" do
    assert_equal 'Ruby-installed-and-working', @language.name
    assert !@mock_file.called?
  end
  
  test "dir is based on name" do
    assert @language.dir.match(@language.name), @language.dir
    assert !@mock_file.called?
  end
  
  test "dir does not end in a slash" do
    assert !@language.dir.end_with?(File::SEPARATOR),
          "!#{@language.dir}.end_with?(#{File::SEPARATOR})"
    assert !@mock_file.called?
  end
  
  test "dir does not have doubled separator" do
    doubled_separator = File::SEPARATOR + File::SEPARATOR
    assert_equal 0, @language.dir.scan(doubled_separator).length
    assert !@mock_file.called?
  end
  
  test "visible files are loaded but not output and not instructions" do
    @mock_file.setup(
      [
         { :visible_filenames => [ 'test_untitled.rb' ] }.inspect,
         "require './untitled'"
      ]
    )
    visible_files = @language.visible_files
    assert_match visible_files['test_untitled.rb'], /^require '\.\/untitled'/ 
    assert_nil visible_files['output']
    assert_nil visible_files['instructions']
  end
  
  test "hidden_filenames defaults to [ ]" do
    @mock_file.setup(
      [ { }.inspect ]
    )    
    assert_equal [ ], @language.hidden_filenames    
  end
  
  test "hidden_filenames set if not defaulted" do
    @mock_file.setup(
      [ { :hidden_filenames => [ 'x', 'y' ] }.inspect ]
    )
    assert_equal [ 'x','y' ], @language.hidden_filenames        
  end
  
  test "support_filenames defaults to [ ]" do
    @mock_file.setup(
      [ { }.inspect ]
    )
    assert_equal [ ], @language.support_filenames    
  end
  
  test "support_filenames set if not defaulted" do
    @mock_file.setup(
      [ { :support_filenames => [ 'a', 'b' ] }.inspect ]
    )
    assert_equal [ 'a','b' ], @language.support_filenames        
  end
  
  test "unit_test_framework is set" do
    @mock_file.setup(
      [ { :unit_test_framework => 'satchmo' }.inspect ]
    )    
    assert_equal 'satchmo', @language.unit_test_framework
    assert @mock_file.called?
  end

    
  test "tab is set if not defaulted" do
    @mock_file.setup(
      [ { :tab_size => 42 }.inspect ]  
    )
    assert_equal 42, @language.tab_size
  end
  
  test "tab defaults to 4" do
    @mock_file.setup(
      [ { }.inspect ]  
    )
    assert_equal 4, @language.tab_size    
  end
  
end
