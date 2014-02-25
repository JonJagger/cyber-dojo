require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'

#looking into passing arguments to tests so I can run them twice
#once in .rb mode and once in .json mode
#
#$mode = ARGV[0] || "rb"
#ARGV[0] = nil

class DojoTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = SpyDisk.new
    @path = 'spied'
    @dojo = Dojo.new(@path)
  end

  def teardown
    Thread.current[:disk] = nil
  end

  test "when no disk on thread ctor raises exception" do
    Thread.current[:disk] = nil
    error = assert_raises(RuntimeError) { Dojo.new('spying') }
    assert_equal "no disk", error.message
  end

  test "path is as set in ctor" do
    assert_equal @path, @dojo.path
  end

  test "[id] gives you kata which knows its path" do
    kata = @dojo['1234567890']
    assert_equal @path+'/katas/12/34567890', kata.path
  end

  test "language gives you language which knows its name" do
    assert_equal 'xxx', @dojo.language('xxx').name
  end

  test "exercise gives you exercise which knows its name" do
    assert_equal 'yyy', @dojo.exercise('yyy').name
  end

  test "create_kata has option to specify .rb format which controls kata's manifest format" do
    manifest = { :id => '45ED23A2F1' }
    kata = @dojo.create_kata(manifest)
    assert_equal "manifest.rb", kata.manifest_filename
    assert kata.dir.write_log.include?(['manifest.rb', manifest.inspect]), kata.dir.write_log.inspect
  end

  test "create_kata has option to specify .json format which controls kata's manifest format" do
    dojo = Dojo.new(@path, "json")
    manifest = { :id => '45ED23A2F1' }
    kata = dojo.create_kata(manifest)
    assert_equal "manifest.json", kata.manifest_filename
    assert kata.dir.write_log.include?(['manifest.json', JSON.unparse(manifest)]), kata.dir.write_log.inspect
  end

end
