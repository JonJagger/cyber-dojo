
# Designed to allow...
#
# o) dojo.languages['name'] to access a specific language
# o) dojo.languages.each to iterate through a dojo's language

class Languages
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    paas.all_languages(self).each { |name| yield self[name] }
  end

  def [](name)
    Language.new(dojo, name)
  end

private

  def paas
    dojo.paas
  end

end
