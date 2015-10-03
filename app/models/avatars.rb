
class Avatars

  def self.names
    %w(alligator buffalo cheetah deer
       elephant frog gorilla hippo
       koala lion moose panda
       raccoon snake wolf zebra
    )
  end

  def initialize(kata)
    @parent = kata
  end

  def each
    return enum_for(:each) unless block_given?
    avatars.each { |_name, avatar| yield avatar }
  end

  def [](name)
    avatars[name]
  end

  def active
    select(&:active?)
  end

  def names
    collect(&:name)
  end

  private

  include Enumerable
  include ExternalParentChain

  def avatars
    # Could do disk[kata.path].exists?('started_avatars.json')
    # and use that if it exists. When number of avatars increases
    # that will become more important
    all = {}
    Avatars.names.each do |name|
      avatar = Avatar.new(@parent, name)
      all[name] = avatar if disk[avatar.path].exists?
    end
    all
  end

end
