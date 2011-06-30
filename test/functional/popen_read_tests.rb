require 'test_helper'
require 'Files'

# > cd cyberdojo/test
# > ruby functional/popen_read_tests.rb

class PopenReadTests < Test::Unit::TestCase

  include Files
  
  def test_popen_read_works_after_refactoring
    assert_equal "Linux\n", popen_read('uname')
  end

end


