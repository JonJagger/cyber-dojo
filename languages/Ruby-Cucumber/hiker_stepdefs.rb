Given /^the hitch-hiker selects some tiles$/ do

end

When /^they spell (\d+) times (\d+)$/ do |x, y|
    @result = x.to_i * y.to_i
end

Then /^the score is (\d+)$/ do |answer|
    answer.to_i.should == @result
end
