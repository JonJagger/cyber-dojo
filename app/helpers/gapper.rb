
# function to insert :gap values into an avatars increments
# to reflect order of increments across all avatars
# For example, pandas, then lions, then lions, then pandas...
# Pandas  Lions
# X       .
# .       X
# X       .
# .       X 


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
    all_incs.each{|inc|
      if inc[:avatar] == name
         bubbles << 'new_' + inc[:outcome].to_s
         previous = inc[:outcome]
      elsif previous == nil
        bubbles << 'no_previous'
      else
        bubbles << 'old_' + previous.to_s
      end
    }
    all_bubbles[name] = bubbles      
  }
  all_bubbles
  # { 'koalas' => [ 'no_previous', 'new_failed', 'old_failed', 'new_error'  ],
  #   'pandas' => [ 'new_failed',  'old_failed', 'new_passed', 'old_passed' ],
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


