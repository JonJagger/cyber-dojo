
class Avatars
  include Enumerable
  include Externals

  def initialize(kata)
    @kata = kata
  end

  def each
    # kata.avatars.each
    disk[@kata.path].each do |name|
      avatar = self[name]
      yield avatar if avatar.exists? && block_given?
    end
  end

  def active
    # kata.avatars.active
    self.select{ |avatar| avatar.active? }
  end

  def [](name)
    # kata.avatars['lion']
    Avatar.new(@kata, name)
  end

  def length
    each.entries.length
  end

end
