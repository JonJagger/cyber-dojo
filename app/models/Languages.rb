
class Languages
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    paas.languages_each(self) do |name|
      yield self[name]
    end
  end

  def [](name)
    Language.new(dojo, name)
  end

private

  def paas
    dojo.paas
  end

end
