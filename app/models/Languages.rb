
class Languages
  include Enumerable

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def each
    # dojo.languages.each
    dir.each { |name| yield self[name] if self[name].exists? }
  end

  def [](name)
    # dojo.languages['name']
    Language.new(dojo, name)
  end

private

  def dir
    dojo.paas.dir(self)
  end

end
