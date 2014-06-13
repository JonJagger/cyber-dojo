
class Avatars
  include Enumerable
  include Externals

  def self.names
      # no two animals start with the same letter
      %w(
          alligator buffalo cheetah deer
          elephant frog gorilla hippo
          koala lion moose panda
          raccoon snake wolf zebra
        )
  end

  def initialize(kata)
    @kata = kata
  end

  def each
    # kata.avatars.each
    dir(@kata.path).each do |name|
      avatar = self[name]
      yield avatar if avatar.exists? && block_given?
    end
  end

  def active
    # kata.avatars.active
    self.select{|avatar| avatar.active?}
  end

  def [](name)
    # kata.avatars['lion']
    Avatar.new(@kata, name)
  end

  def length
    each.entries.length
  end

end
