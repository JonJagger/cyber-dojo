require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/stub_disk'

class LanguageTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = StubDisk.new
    @language = Dojo.new('stubbed').language('Ruby')
  end

  def teardown
    Thread.current[:disk] = nil
  end

  def stub_manifest(manifest)
    @disk[@language.dir, 'manifest.json'] = JSON.unparse(manifest)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false when language folder does not exist" do
    assert !Dojo.new('stubbed').language('xxxx').exists?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is true when language folder exists" do
    @disk[@language.dir] = true
    assert @language.exists?
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
    assert !@language.dir.end_with?(@disk.dir_separator)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not have doubled separator" do
    doubled_separator = @disk.dir_separator * 2
    assert_equal 0, @language.dir.scan(doubled_separator).length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is not in manifest then visible_files is empty hash" do
    stub_manifest({})
    assert_equal({ }, @language.visible_files)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is empty array in manifest then visible_files is empty hash" do
    stub_manifest({ 'visible_filenames' => [ ] })
    assert_equal({ }, @language.visible_files)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is non-empty array in manifest then visible_files are loaded but not output and not instructions" do
    stub_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
    @disk[@language.dir, 'test_untitled.rb'] = 'content'
    visible_files = @language.visible_files
    assert_equal( { 'test_untitled.rb' => 'content' }, visible_files)
    assert_nil visible_files['output']
    assert_nil visible_files['instructions']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "support_filenames defaults to [ ]" do
    stub_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
    assert_equal [ ], @language.support_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "support_filenames set if not defaulted" do
    support_filenames = [ 'x.jar', 'y.dll' ]
    stub_manifest({ 'support_filenames' => support_filenames })
    assert_equal support_filenames, @language.support_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "highlight_filenames defaults to [ ]" do
    stub_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
    assert_equal [ ], @language.support_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "highlight_filenames set if not defaulted" do
    visible_filenames = [ 'x.hpp', 'x.cpp' ]
    highlight_filenames = [ 'x.hpp' ]
    stub_manifest({
        'visible_filenames' => visible_filenames,
        'highlight_filenames' => highlight_filenames
      })
    assert_equal highlight_filenames, @language.highlight_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "unit_test_framework is set" do
    unit_test_framework = 'Satchmo'
    stub_manifest({ 'unit_test_framework' => unit_test_framework })
    assert_equal unit_test_framework, @language.unit_test_framework
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab_size is set if not defaulted" do
    tab_size = 42
    stub_manifest({ 'tab_size' => tab_size })
    assert_equal tab_size, @language.tab_size
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab_size defaults to 4" do
    stub_manifest({ })
    assert_equal 4, @language.tab_size
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab is 7 spaces if tab_size is 7" do
    tab_size = 7
    stub_manifest({ 'tab_size' => tab_size })
    assert_equal " "*tab_size, @language.tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab defaults to 4 spaces" do
    stub_manifest({ })
    assert_equal " "*4, @language.tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if manifest.rb and manifest.json exist, json is used" do
    @disk[@language.dir,'manifest.json'] = JSON.unparse({'tab_size' => 4})
    @disk[@language.dir,'manifest.rb'] = { :tab_size => 8 }.inspect
    assert_equal " "*4, @language.tab
  end

end
