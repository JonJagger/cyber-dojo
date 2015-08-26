#!/bin/bash ../test_wrapper.sh

require_relative 'lib_test_base'

class IdSplitterTests < LibTestBase

  include IdSplitter

  test 'outer(id) is first two chars of id' do
    assert_equal '23', outer('23111966')
  end

  test 'inner(id) is all but first two chars of id' do
    assert_equal '111966', inner('23111966')
  end

end
