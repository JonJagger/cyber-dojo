#!/usr/bin/env ruby

require_relative 'lib_test_base'

class OneSelfTests < LibTestBase

  include ExternalOneSelf
  include ExternalSetter
  
  class MockOneSelf
    def initialize
      @ok_called,@throwing_called,@throwing_finished = false,false,false
    end
    attr_reader :ok_called, :throwing_called, :throwing_finished
    def ok
      @ok_called = true
      42
    end
    def throwing
      @throwing_called = true
      raise RuntimeError.new("")
      @throwing_finished = true
    end
  end
  
  def setup
    @mock = MockOneSelf.new
    reset_external(:one_self, @mock);
  end

  test '[one_self.method] returns result of method when it does not throw' do
    assert !@mock.ok_called
    assert !@mock.throwing_called
    assert !@mock.throwing_finished
    assert_equal 42, one_self.ok
    assert @mock.ok_called
    assert !@mock.throwing_called  
    assert !@mock.throwing_finished      
  end
  
  test '[one_self.method] silently swallows raised exception' do
    assert !@mock.ok_called
    assert !@mock.throwing_called
    assert !@mock.throwing_finished
    one_self.throwing
    assert !@mock.ok_called
    assert @mock.throwing_called        
    assert !@mock.throwing_finished
  end
  
end
