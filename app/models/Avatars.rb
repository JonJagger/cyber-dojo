
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

  attr_reader :kata

  def each
    paas.avatars_each(kata) do |name|
      yield self[name]
    end
  end

  def [](name)
    Avatar.new(kata,name)
  end

private

  def paas
    kata.dojo.paas
  end

end
