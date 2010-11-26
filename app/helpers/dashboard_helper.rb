
module DashboardHelper

  def new_gapper(dojo)
    all = {}
    dojo.avatars.each do |avatar|
      all_incs = avatar.increments
      max_increments_displayed = 75
      len = [all_incs.length, max_increments_displayed].min
      all[avatar.name] = all_incs[-len,len]
    end
    all
  end
  
  # function to insert :gap values into an avatars increments to
  # reflect order of increments across all avatars for the 
  # traffic light dashboard
  # Eg in submission in time of pandas, lions, lions, frogs, pandas...
  # looks like this (where each X is a traffic light)
  #
  # pandas X...X
  # lions  .XX..
  # frogs  ...X.

  def gapper(dojo)
      
    all_incs, all_names = [], Set.new()
    dojo.avatars.each do |avatar|
      all_names.add(avatar.name)
      all_incs += marked_increments(avatar)
    end

    all_incs.sort! {|lhs,rhs| moment(lhs) <=> moment(rhs) }

    gap = { :outcome => :gap }
    
    all_bubbles = {}
    all_names.each do |name|
      bubbles, previous = [], nil
      all_incs.each { |inc| bubbles << (inc[:avatar] == name ? inc : gap) }
      max_increments_displayed = 125
      len = [bubbles.length, max_increments_displayed].min
      all_bubbles[name] = bubbles[-len,len]
    end

    all_bubbles
  end


  def marked_increments(avatar)
    incs = avatar.increments
    incs.each do |inc|
      inc[:avatar] = avatar.name
    end
    incs
  end

  def moment(at)
    Time.utc(*at[:time])
  end

end

