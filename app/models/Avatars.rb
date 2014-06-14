
# kata.avatars.active
# kata.avatars['lion']
# kata.avatars.each {|avatar| ...}

class Avatars
  include Enumerable
  include Externals

  def initialize(kata)
    @kata = kata
  end

  def each
    disk[@kata.path].each do |name|
      avatar = self[name]
      yield avatar if avatar.exists? && block_given?
    end
  end

  def active
    self.select{ |avatar| avatar.active? }
  end

  def [](name)
    Avatar.new(@kata, name)
  end

end
