require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/popen_read_tests.rb

class PopenReadTests < Test::Unit::TestCase

  def test_popen_read_works_after_refactoring
    assert_equal "Linux\n", popen_read('uname')
  end

end


