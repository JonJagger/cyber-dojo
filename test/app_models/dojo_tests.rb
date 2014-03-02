require File.dirname(__FILE__) + '/../test_helper'
require File.dirname(__FILE__) + '/spy_disk'

class DojoTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = @disk = SpyDisk.new
    @path = 'spied/'
  end

  def teardown
    @disk.teardown
    Thread.current[:disk] = nil
  end

  def rb_and_json(&block)
    block.call('rb')
    teardown
    setup
    block.call('json')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when no disk on thread ctor raises exception" do
    rb_and_json(&Proc.new{|format|
      Thread.current[:disk] = nil
      error = assert_raises(RuntimeError) { Dojo.new('spied/',format) }
      assert_equal 'no disk', error.message
    })
  end

  test "path is as set in ctor" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new(@path,format)
      assert_equal @path, dojo.path
    })
  end

  test "[id] gives you kata which knows its path" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new(@path,format)
      kata = dojo['1234567890']
      assert_equal @path+'katas/12/34567890/', kata.path
    })
  end

  test "language gives you language which knows its name" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new(@path,format)
      assert_equal 'xxx', dojo.language('xxx').name
    })
  end

  test "exercise gives you exercise which knows its name" do
    rb_and_json(&Proc.new{|format|
      dojo = Dojo.new(@path,format)
      assert_equal 'yyy', dojo.exercise('yyy').name
    })
  end

  test "create_kata has option to specify .rb format which controls kata's manifest format" do
    dojo = Dojo.new(@path,'rb')
    manifest = { :id => '45ED23A2F1' }
    kata = dojo.create_kata(manifest)
    assert_equal 'manifest.rb', kata.manifest_filename
    assert kata.dir.log.include?(['write','manifest.rb', manifest.inspect]), kata.dir.log.inspect
  end

  test "create_kata has option to specify .json format which controls kata's manifest format" do
    dojo = Dojo.new(@path, 'json')
    manifest = { :id => '45ED23A2F1' }
    kata = dojo.create_kata(manifest)
    assert_equal "manifest.json", kata.manifest_filename
    assert kata.dir.log.include?(['write','manifest.json', JSON.unparse(manifest)]), kata.dir.log.inspect
  end

end
