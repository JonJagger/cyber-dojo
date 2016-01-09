
class Katas
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
    @path = config['root']['katas']
  end

  def path
    slashed(@path)
  end

  def parent
    @dojo
  end

  def each
    return enum_for(:each) unless block_given?
    history.katas_each(self) do |id|
      yield Kata.new(self, id)
    end
  end

  def [](id)
    return nil if !valid?(id)
    kata = Kata.new(self, id)
    history.kata_exists?(kata) ? kata : nil
  end

  def complete(id)
    history.katas_complete_id(self, id)
  end

  private

  include ExternalParentChainer
  include Slashed

  def valid?(id)
    id.class.name == 'String' &&
      id.length == 10 &&
        id.chars.all? { |char| hex?(char) }
  end

  def hex?(char)
    '0123456789ABCDEF'.include?(char)
  end

end
