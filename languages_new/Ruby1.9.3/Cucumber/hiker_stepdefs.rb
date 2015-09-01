Given /^the hitch-hiker selects some tiles$/ do

end

When /^they spell (\d+) times (\d+)$/ do |x, y|
    @result = answer(x.to_i,y.to_i)
end

Then /^the score is (\d+)$/ do |answer|
    expect(answer.to_i).to eq(@result)
end
