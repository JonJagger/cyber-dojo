require './spec_helper'

require './untitled'

describe "untitled" do
  subject do
    answer
  end
  
  context "sums" do
    it "has answer" do
      verify do
        subject
      end
    end
  end
end
