
# kata.avatars.active
# kata.avatars['lion']
# kata.avatars.each {|avatar| ...}

class Avatars
  include Enumerable

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

  def initialize(kata,externals)
    @kata,@externals = kata,externals
  end

  def each
    Avatars.names.each do |name|
      avatar = self[name]
      yield avatar if avatar.exists? && block_given?
    end
  end

  def active
    self.select{ |avatar| avatar.active? }
  end

  def [](name)
    Avatar.new(@kata,name,@externals)
  end

  def count
    entries.length
  end

end
