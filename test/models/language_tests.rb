require File.dirname(__FILE__) + '/../coverage_test_helper'
require File.dirname(__FILE__) + '/stub_disk_file'

class LanguageTests < ActionController::TestCase
  
  def setup
    @stub_file = StubDiskFile.new
    Thread.current[:file] = @stub_file    
    @language = Language.new(root_dir, 'Ruby')    
  end
  
  def teardown
    Thread.current[:file] = nil
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "name is as set in ctor" do
    assert_equal 'Ruby', @language.name
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "dir is based on name" do
    assert @language.dir.match(@language.name), @language.dir
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "dir does not end in a slash" do
    assert !@language.dir.end_with?(@stub_file.separator),
          "!#{@language.dir}.end_with?(#{@stub_file.separator})"
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "dir does not have doubled separator" do
    doubled_separator = @stub_file.separator * 2
    assert_equal 0, @language.dir.scan(doubled_separator).length
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "when :visible_filenames is not in manifest then visible_files is empty hash" do
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
      }.inspect
    })
    assert_equal({ }, @language.visible_files)
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "when :visible_filenames is empty array in manifest then visible_files is empty hash" do
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :visible_filenames => [ ]
      }.inspect
    })
    assert_equal({ }, @language.visible_files)
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "when :visible_filenames is non-empty array in manifest then visible_files are loaded but not output and not instructions" do
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :visible_filenames => [ 'test_untitled.rb' ]
      }.inspect
    })
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'test_untitled.rb',
      :content => 'content'
    })    
    visible_files = @language.visible_files
    assert_equal( { 'test_untitled.rb' => 'content' }, @language.visible_files)
    assert_nil visible_files['output']
    assert_nil visible_files['instructions']
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "support_filenames defaults to [ ]" do
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :visible_filenames => [ 'test_untitled.rb' ]
      }.inspect
    })        
    assert_equal [ ], @language.support_filenames    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "support_filenames set if not defaulted" do
    support_filenames = [ 'x.jar', 'y.dll' ]
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :support_filenames => support_filenames
      }.inspect
    })        
    assert_equal support_filenames, @language.support_filenames        
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "highlight_filenames defaults to [ ]" do
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :visible_filenames => [ 'test_untitled.rb' ]
      }.inspect
    })        
    assert_equal [ ], @language.support_filenames        
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "highlight_filenames set if not defaulted" do
    visible_filenames = [ 'x.hpp', 'x.cpp' ]
    highlight_filenames = [ 'x.hpp' ]
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :visible_filenames => visible_filenames,
        :highlight_filenames => highlight_filenames
      }.inspect
    })        
    assert_equal highlight_filenames, @language.highlight_filenames            
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "unit_test_framework is set" do
    unit_test_framework = 'Satchmo'
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :unit_test_framework => unit_test_framework
      }.inspect
    })        
    assert_equal unit_test_framework, @language.unit_test_framework
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "tab_size is set if not defaulted" do
    tab_size = 42
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :tab_size => tab_size
      }.inspect
    })            
    assert_equal tab_size, @language.tab_size
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "tab_size defaults to 4" do
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
    })            
    assert_equal 4, @language.tab_size    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "tab is 7 spaces if tab_size is 7" do
    tab_size = 7
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => {
        :tab_size => tab_size
      }.inspect
    })            
    assert_equal " "*tab_size, @language.tab
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -   

  test "tab defaults to 4 spaces" do
    @stub_file.read=({
      :dir => @language.dir,
      :filename => 'manifest.rb',
      :content => { }.inspect
    })            
    assert_equal " "*4, @language.tab
  end  
  
end
