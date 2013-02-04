require 'rspec'
require 'test/unit/assertions'
require './untitled'

describe "untitled" do
  include Test::Unit::Assertions
  
  context "when doing sums" do
    it "multiplies correctly" do
      assert_equal 6 * 9, answer
    end
  end  

end
