
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
    paas.all_avatars(@kata).each { |name| yield self[name] }
  end

  def [](name)
    Avatar.new(@kata,name)
  end

private

  def paas
    @kata.dojo.paas
  end

end
