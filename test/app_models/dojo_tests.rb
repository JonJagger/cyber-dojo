require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'

#looking into passing arguments to tests so I can run them twice
#once in .rb mode and once in .json mode
#
#$mode = ARGV[0] || "rb"
#ARGV[0] = nil

class DojoTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    @dir = '/spied'
    @dojo = Dojo.new(@dir)
  end

  def teardown
    Thread.current[:disk] = nil
  end

  test "dir is as set in ctor" do
    assert_equal @dir, @dojo.dir
  end

  test "[id] gives you kata which knows its dir" do
    assert_equal @dir+'/katas/12/34567890', @dojo['1234567890'].dir
  end

  test "language gives you language which knows its name" do
    assert_equal 'xxx', @dojo.language('xxx').name
  end

  test "exercise gives you exercise which knows its name" do
    assert_equal 'yyy', @dojo.exercise('yyy').name
  end

  test "dojo has option to specify format as .rb which controls kata's manifest format" do
    dir = 'spied'
    dojo = Dojo.new(dir, "rb")
    id = '45ED23A2F1'
    manifest = { :id => id }
    kata = @dojo.create_kata(manifest)
    assert_equal "manifest.rb", kata.manifest_filename
    assert @disk[kata.dir].write_log.include?(['manifest.rb', manifest.inspect])
  end

  test "dojo has option to specify format as .json which controls kata's manifest format" do
    dir = 'spied'
    dojo = Dojo.new(dir, "json")
    id = '45ED23A2F1'
    manifest = { :id => id }
    kata = dojo.create_kata(manifest)
    assert_equal "manifest.json", kata.manifest_filename
    assert @disk[kata.dir].write_log.include?(['manifest.json', JSON.unparse(manifest)]), @disk[kata.dir].write_log.inspect
  end

end
