#!/bin/bash ../test_wrapper.sh

require_relative './app_lib_test_base'

class LineSplitterTests < AppLibTestBase

  def line_split(lines)
    LineSplitter.line_split(lines)
  end

  #- - - - - - - - - - - - - - - -

  test 'splitting nil is an empty array' do
    assert_equal [ ], line_split(nil)
  end

  #- - - - - - - - - - - - - - - -

  test 'splitting empty string is empty string in array' do
    assert_equal [ '' ], line_split('')
  end

  #- - - - - - - - - - - - - - - -

  test 'splitting solitary newline is empty string in array' do
    assert_equal [''], line_split("\n")
  end

  #- - - - - - - - - - - - - - - -

  test 'retains empty lines between newlines' do
    # regular split doesn't do what I need...
    assert_equal [ ], "\n\n".split("\n")
    # So I have to roll my own...
    assert_equal [ '', '' ], line_split("\n"+"\n")
    assert_equal ['a','b',''], line_split('a'+"\n"+'b'+"\n"+"\n")
    assert_equal ['a','b','',''], line_split('a'+"\n"+'b'+"\n"+"\n"+"\n")
  end

  #- - - - - - - - - - - - - - - -

  test 'doesnt add extra empty line if string ends in newline' do
    assert_equal ['a'], line_split('a')
    assert_equal ['a'], line_split('a'+"\n")

    assert_equal ['a','b'], line_split('a'+"\n"+'b')
    assert_equal ['a','b'], line_split('a'+"\n"+'b'+"\n")
  end

end
