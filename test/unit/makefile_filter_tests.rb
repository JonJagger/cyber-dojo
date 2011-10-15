require File.dirname(__FILE__) + '/../test_helper'
require 'test_runner_helper'

# > ruby test/functional/makefile_filter_tests.rb

class MakefileFilterTests < ActionController::TestCase

  include TestRunnerHelper
  
  def test_when_filename_not_makefile
     name     = 'not_makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "    abc"
     assert_equal expected, actual
  end

  def test_when_filename_is_makefile
     name     = 'makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

  def test_when_filename_is_Makefile_with_uppercase_M
     name     = 'Makefile'
     content  = "    abc"
     actual   = makefile_filter(name, content)
     expected = "\tabc"
     assert_equal expected, actual
  end

end
