#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class PrevNextRingTests < AppLibTestBase

  include PrevNextRing

  #------------------------------------------------------------------

  def assert_prev(arg,entries,expected)
    clone = entries.clone
    assert_equal expected, prev_ring(clone,arg)
    assert_equal clone, entries
  end

  def assert_next(arg,entries,expected)
    clone = entries.clone
    assert_equal expected, next_ring(clone,arg)
    assert_equal clone, entries
  end

  #------------------------------------------------------------------

  test 'previous when single entry is empty string' do
    assert_prev('a', %w{ a }, '')
  end

  test 'previous in two entries' do
    assert_prev('a', %w{ a b }, 'b')
    assert_prev('b', %w{ a b }, 'a')
  end

  test 'previous in three entries' do
    assert_prev('a', %w{ a b c }, 'c')
    assert_prev('b', %w{ a b c }, 'a')
    assert_prev('c', %w{ a b c }, 'b')
  end

  test 'previous in four entries' do
    assert_prev('a', %w{ a b c d }, 'd')
    assert_prev('b', %w{ a b c d }, 'a')
    assert_prev('c', %w{ a b c d }, 'b')
    assert_prev('d', %w{ a b c d }, 'c')
  end

  #------------------------------------------------------------------

  test 'next when single entry is empty string' do
    assert_next('a', %w{ a }, '')
  end

  test 'next in two entries' do
    assert_next('a', %w{ a b }, 'b')
    assert_next('b', %w{ a b }, 'a')
  end

  test 'next in three entries' do
    assert_next('a', %w{ a b c }, 'b')
    assert_next('b', %w{ a b c }, 'c')
    assert_next('c', %w{ a b c }, 'a')
  end

  test 'next in four entries' do
    assert_next('a', %w{ a b c d }, 'b')
    assert_next('b', %w{ a b c d }, 'c')
    assert_next('c', %w{ a b c d }, 'd')
    assert_next('d', %w{ a b c d }, 'a')
  end

end
