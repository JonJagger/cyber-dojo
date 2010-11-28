
module DashboardHelper

  def all_avatar_increments(dojo)
    all = {}
    dojo.avatars.each do |avatar|
      all_incs = avatar.increments
      max_increments_displayed = 75
      len = [all_incs.length, max_increments_displayed].min
      all[avatar.name] = all_incs[-len,len]
    end
    all
  end

end

