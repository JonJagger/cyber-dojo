#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class Wibble
  def answer
    42
  end
  def question
    'what do you get...'
  end
end

class MoxyTests < LibTestBase

  def setup
    super
    @moxy = Moxy.new(nil)
  end

  test '3AF9D3',
  'when proxy is not set, attempt to proxy raises' do
    assert_raises(RuntimeError) { @moxy.answer }
  end

  # - - - - - - - - - - - - - - - - - -

  test 'E9A011',
  'when proxy is not set, attempt to setup a mock raises' do
    assert_raises(RuntimeError) { @moxy.mock(:answer) }
  end

  # - - - - - - - - - - - - - - - - - -

  test '904D37',
  'setting the proxy to nil raises' do
    assert_raises(RuntimeError) { @moxy.proxy(nil) }
  end

  # - - - - - - - - - - - - - - - - - -

  test '067DAA',
  'setting proxy twice raises' do
    @moxy.proxy(Wibble.new)
    assert_raises(RuntimeError) { @moxy.proxy(Wibble.new) }
  end

  # - - - - - - - - - - - - - - - - - -

  test 'F5F87C',
  'setting the proxy to non-nil succeeds' do
    @moxy.proxy(Wibble.new)
  end

  # - - - - - - - - - - - - - - - - - -

  test 'C5C1F2',
  'when no mock is setup all calls forward to the proxy target' do
    @moxy.proxy(w = Wibble.new)
    assert_equal 42, @moxy.answer
  end

  # - - - - - - - - - - - - - - - - - -

  test '50078B',
  'setting up a mock that the proxy does not respond to raises' do
    @moxy.proxy(Wibble.new)
    assert_raises(RuntimeError) { @moxy.mock(:nope) }
  end

  # - - - - - - - - - - - - - - - - - -

  test 'D59190',
  'setting up a mock for a command already mocked (and unrequited) raises' do
    @moxy.proxy(Wibble.new)
    @moxy.mock(:answer) {}
    assert_raises(RuntimeError) { @moxy.mock(:answer) }
  end

  # - - - - - - - - - - - - - - - - - -

  test '7C0D68',
  'when a mock for a method is setup, calls to a different method forward to the proxy target' do
    @moxy.proxy(Wibble.new)
    block_called = false
    @moxy.mock(:question) { block_called = true }
    assert_equal 42, @moxy.answer
    refute block_called
  end

  # - - - - - - - - - - - - - - - - - -

  test '386A5D',
  'when a mock for a method is setup, the next call to that method goes to the supplied block' do
    @moxy.proxy(Wibble.new)
    block_called = false
    @moxy.mock(:answer) { |a,b|
      assert_equal 2, a
      assert_equal 3, b
      block_called = true
      a+b
    }
    assert_equal 5, @moxy.answer(2,3)
    assert block_called
  end

end
