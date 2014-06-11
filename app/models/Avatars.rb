
class Avatars
  include Enumerable

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
    paas.all_avatars(@kata).each { |name| yield self[name] if block_given? }
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

private

  def paas
    @kata.dojo.paas
  end

end
