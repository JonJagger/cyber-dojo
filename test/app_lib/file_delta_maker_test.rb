#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class FileDeltaMakerTests < AppLibTestBase

  test 'unchanged files seen as :unchanged' do
    was = { 'wibble.h' => 3424234 }
    now = { 'wibble.h' => 3424234 }
    delta = make_delta(was, now)
    assert_equal ['wibble.h'], delta[:unchanged]
    assert_equal [ ],          delta[:changed]
    assert_equal [ ],          delta[:deleted]
    assert_equal [ ],          delta[:new]
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'changed files seen as :changed' do
    was = { 'wibble.h' => 52674 }
    now = { 'wibble.h' => 3424234 }
    delta = make_delta(was, now)
    assert_equal ['wibble.h'], delta[:changed]
    assert_equal [ ],          delta[:unchanged]
    assert_equal [ ],          delta[:deleted]
    assert_equal [ ],          delta[:new]
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'new files seen as :new' do
    was = { }
    now = { 'wibble.h' => 52674 }
    delta = make_delta(was, now)
    assert_equal ['wibble.h'], delta[:new]
    assert_equal [ ],          delta[:changed]
    assert_equal [ ],          delta[:deleted]
    assert_equal [ ],          delta[:unchanged]
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'deleted files seen as :deleted' do
    was = { 'wibble.h' => 52674 }
    now = { }
    delta = make_delta(was, now)
    assert_equal ['wibble.h'], delta[:deleted]
    assert_equal [ ],          delta[:new]
    assert_equal [ ],          delta[:changed]
    assert_equal [ ],          delta[:unchanged]
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'example with :unchanged, :changed, :deleted, and :new' do
    was = { 'wibble.h' => 52674, 'wibble.c' => 3424234, 'fubar.h' => -234 }
    now = { 'wibble.h' => 52674, 'wibble.c' => 46532, 'snafu.c' => -345345 }
    delta = make_delta(was, now)
    assert_equal ['wibble.h'], delta[:unchanged]
    assert_equal ['wibble.c'], delta[:changed]
    assert_equal ['fubar.h'],  delta[:deleted]
    assert_equal ['snafu.c'],  delta[:new]
  end

  def make_delta(was, now)
    FileDeltaMaker.make_delta(was,now)
  end

end
