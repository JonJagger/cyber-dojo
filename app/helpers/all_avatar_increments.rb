
def all_avatar_increments(dojo)
  all = {}
  dojo.avatars.each do |avatar|
    max_increments_displayed = 65
    all[avatar.name] = recent(avatar.increments, max_increments_displayed)
  end
  all
end

