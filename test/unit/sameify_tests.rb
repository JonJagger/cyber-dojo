require File.dirname(__FILE__) + '/../test_helper'
require 'Sameify'

# > ruby test/functional/sameify_tests.rb

class SameifyTests < ActionController::TestCase

  def test_sameify_with_joined_newlines
    
    expected =
    [
      { :line => "once",        :type => :same, :number => 1 },
      { :line => "upon a",      :type => :same, :number => 2 },
      { :line => "time",        :type => :same, :number => 3 },
      { :line => "in the west", :type => :same, :number => 4 },
      { :line => "",            :type => :same, :number => 5 },
      { :line => "",            :type => :same, :number => 6 },
    ]
    assert_equal expected, sameify(great_great_film + "\n\n")
    
  end
  
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
