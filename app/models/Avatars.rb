
class Avatars

  def self.names
      %w(
          alligator buffalo cheetah deer
          elephant frog gorilla hippo
          koala lion moose panda
          raccoon snake wolf zebra
        )
  end

  def self.valid?(name)
    names.include?(name)
  end

  # - - - - - - - - - - - - - - - - - - -

  include Enumerable

  def initialize(kata,externals)
    @kata,@externals = kata,externals
  end

  def each
    # kata.avatars.each {|avatar| ...}
    Avatars.names.each do |name|
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
    Avatar.new(@kata,name,@externals)
  end

  def count
    # kata.avatars.count
    entries.length
  end

end
