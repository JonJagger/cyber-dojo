
def age_or_closed(dojo)
  if dojo.closed
    'This CyberDojo has ended'
  else
    age = dojo.age
    "%02dh:%02dm:%02ds" % [ age[:hours], age[:mins], age[:secs] ]
  end
end
 

