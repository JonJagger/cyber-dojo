require './spec_helper'

require './untitled'

describe "untitled" do
  subject do
    answer
  end
  
  context "when doing sums" do
    it "has the answer" do
      verify do
        subject
      end
    end
  end
end
