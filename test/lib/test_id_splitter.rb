#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class IdSplitterTests < LibTestBase

  include IdSplitter

  test 'C45B5C',
  'outer(id) if first two chars of id in uppercase' do
    assert_equal '23', outer('23111966')
    assert_equal 'AB', outer('ab111966')
  end

  test '03AE98',
  'inner(id) is all but first two chars of id in uppercase' do
    assert_equal '111966', inner('23111966')
    assert_equal 'AB1966', inner('23ab1966')
  end

end
