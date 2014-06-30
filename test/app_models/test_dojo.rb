#!/usr/bin/env ruby

require_relative 'model_test_base'

class DojoTests < ModelTestBase

  test "ctor raises if thread[:git] not set" do
    externals = {
      :disk => dummy,
      :runner => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake/',externals)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "ctor raises if thread[:disk] not set" do
    externals = {
      :git => dummy,
      :runner => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake/',externals)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "ctor raises if thread[:runner] not set" do
    externals = {
      :disk => dummy,
      :git => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake/',externals)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "ctor raises if path does not end in /" do
    externals = {
      :disk => dummy,
      :git => dummy
    }
    assert_raise RuntimeError do
      Dojo.new('fake',externals)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def dummy
    Object.new
  end

end
