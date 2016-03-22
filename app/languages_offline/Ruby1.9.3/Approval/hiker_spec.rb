require './spec_helper'

require './hiker'

describe "hiker" do
  subject do
    answer
  end

  context "life the universe and everything" do
    it "has answer" do
      verify do
        subject
      end
    end
  end
end
