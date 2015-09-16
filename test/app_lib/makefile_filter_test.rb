#!/bin/bash ../test_wrapper.sh

require_relative './AppLibTestBase'

class MakefileFilterTests < AppLibTestBase

  test 'C88333',
  "not makefile leaves leading whitespace untouched" do
    check('notMakefile', "            abc", "            abc")
    check('notMakefile', "        abc", "        abc")
    check('notMakefile', "    abc", "    abc")
    check('notMakefile', "\tabc", "\tabc")
  end

  test '19B19D',
  "makefile converts all leading whitespace on a line to a single tab" do
    check('makefile', "            abc", "\tabc")
    check('makefile', "        abc", "\tabc")
    check('makefile', "    abc", "\tabc")
    check('makefile', "\tabc", "\tabc")
  end

  test '0AE03C',
  "Makefile converts all leading whitespace on a line to a single tab" do
    check('Makefile', "            abc", "\tabc")
    check('Makefile', "        abc", "\tabc")
    check('Makefile', "    abc", "\tabc")
    check('Makefile', "\tabc", "\tabc")
  end

  test '0A602B',
  "makefile converts all leading whitespace to single tab for all lines in any line format" do
    check('makefile', "123\n456", "123\n456")
    check('makefile', "123\r\n456", "123\n456")

    check('makefile', "    123\n456", "\t123\n456")
    check('makefile', "    123\r\n456", "\t123\n456")

    check('makefile', "123\n    456", "123\n\t456")
    check('makefile', "123\r\n    456", "123\n\t456")

    check('makefile', "    123\n   456", "\t123\n\t456")
    check('makefile', "    123\r\n   456", "\t123\n\t456")

    check('makefile', "    123\n456\n   789", "\t123\n456\n\t789")
    check('makefile', "    123\r\n456\n   789", "\t123\n456\n\t789")
    check('makefile', "    123\n456\r\n   789", "\t123\n456\n\t789")
    check('makefile', "    123\r\n456\r\n   789", "\t123\n456\n\t789")
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def check(filename, content, expected)
    assert_equal expected, MakefileFilter.filter(filename,content)
  end

end
