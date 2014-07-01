
# kata.avatars.active
# kata.avatars['lion']
# kata.avatars.each {|avatar| ...}

class Avatars
  include Enumerable

  def initialize(kata,externals)
    @kata,@externals = kata,externals
  end

  def each
    Avatar.names.each do |name|
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

end
