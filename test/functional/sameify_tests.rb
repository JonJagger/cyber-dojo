require 'test_helper'

# > cd cyberdojo/test
# > ruby functional/sameify_tests.rb

class SameifyTests < ActionController::TestCase

  def test_sameify
    expected =
    [
      { :line => "once",        :type => :same, :number => 1 },
      { :line => "upon a",      :type => :same, :number => 2 },
      { :line => "time",        :type => :same, :number => 3 },
      { :line => "in the west", :type => :same, :number => 4 },
    ]
    assert_equal expected, sameify(great_great_film)
  end
  
  def great_great_film 
<<HERE
once
upon a
time
in the west
HERE
  end
  
end
