
# function to insert :gap values into an avatars increments
# to reflect order of increments across all avatars
# For example, alligators, then lions, then lions, then alligators...
# Alligators: X     X
# Lions     :   X X

def gapper(all)

  avs = []
  all.each do |avatar|
    avs << MockAvatar.new(avatar.name, avatar.increments)
  end
  mc = MockKata.new(avs)

  # record avatar for each increment to reform avatar groups later
  mc.avatars.each do |avatar|
    avatar.increments.each {|inc| inc[:avatar] = avatar.name }
  end

  # merge all increments across avatars
  flat = []
  mc.avatars.each {|avatar| avatar.increments.each { |inc| flat << inc } }
  
  # sort based on :time
  flat.sort! {|lhs,rhs| Time.utc(*lhs[:time]) <=> Time.utc(*rhs[:time]) }

  # record ordinal value across all avatars
  flat.each_with_index {|h,n| h[:ordinal] = n }

  # regroup by :avatar
  flat = flat.group_by {|inc| inc[:avatar] }

  # calculate ordinal gaps
  flat.each do |avatar,increments|
    prev = -1
    increments.each do |inc|
      inc[:gap] = inc[:ordinal] - prev - 1
      prev = inc[:ordinal]
    end
  end

  result = []
  flat.each do |avatar,increments|
    result << MockAvatar.new(avatar,increments)
  end
  result

end

class MockAvatar
  def initialize(name,incs)
    @name,@incs = name,incs
  end

  def name
    @name
  end

  def increments
    @incs
  end

  def to_s
    inspect
  end

end

class MockKata
  def initialize(avatars)
    @avatars = avatars
  end

  def avatars
    @avatars
  end
end


