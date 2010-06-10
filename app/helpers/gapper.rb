
# function to insert :gap values into an avatars increments to
# reflect order of increments across all avatars for the dashboard
# Eg in submission in time of pandas, lions, lions, frogs, pandas...
# looks like thsi:
#
# pandas X...X
# lions  .XX..
# frogs  ...X.


def gapper(dojo)
      
  all_incs, all_names = [], Set.new()
  dojo.katas.each {|kata|
    kata.avatars.each {|avatar|
      all_names.add(avatar.name)
      all_incs += marked_increments(avatar)
    }
  }

  all_incs.sort! {|lhs,rhs| moment(lhs) <=> moment(rhs) }
  
  all_bubbles = {}
  all_names.each {|name|
    bubbles, previous = [], nil
    all_incs.each {|inc|
      if inc[:avatar] == name
         bubbles << 'new_' + inc[:outcome].to_s
         previous = inc[:outcome]
      elsif previous == nil
        bubbles << 'no_previous'
      else
        bubbles << 'old_' + previous.to_s
      end
    }
    all_bubbles[name] = bubbles.reverse   
  }
  all_bubbles
  # eg
  # { 'koalas' => [ 'new_error',  'old_failed', 'new_failed, 'no_previous' ], 
  #   'pandas' => [ 'old_passed', 'new_passed', 'old_failed', new_failed'  ],
  # }
end


def marked_increments(avatar)
  incs = avatar.increments
  incs.each {|inc|
    inc[:avatar] = avatar.name
  }
  incs
end


def moment(at)
  Time.utc(*at[:time])
end


def shared(gapped)  
  # In a single increment column all avatars except one 
  # have an old outcome, and one avatar has a new outcome.
  # NB: This will change if a time-period increment is introduced.
  # The run-test outcomes dominate each other in the follow chain
  outcomes = [ :new_failed, :old_failed, 
               :new_error,  :old_error,
               :new_passed ]
  # There is no entry for old_passed as that cannot be the shared
  # outcome since there must be at least one new outcome.
  rgy = []
  gapped.inject([]) {|s,kv| s << kv[1]}.transpose.each do |all| 
    outcomes.each do |outcome|
      if contains(all, outcome)
        rgy << outcome
        break
      end
    end
  end
  rgy
end


def contains(all, find)
  return all.select {|one| one.index(find.to_s)}.size > 0
end

