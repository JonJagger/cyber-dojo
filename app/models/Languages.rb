
class Languages
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    # dojo.languages.each
    paas.all_languages(self).each { |name| yield self[name] }
  end

  def [](name)
    # dojo.languages['name']
    Language.new(dojo, name)
  end

private

  def paas
    dojo.paas
  end

end
