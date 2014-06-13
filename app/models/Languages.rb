require 'Externals'

class Languages
  include Enumerable
  include Externals

  def initialize(dojo)
    @dojo = dojo
  end

  attr_reader :dojo

  def path
    dojo.path + 'languages/'
  end

  def each
    # dojo.languages.each
    dir(path).each do |name|
      language = self[name]
      yield language if language.exists?
    end
  end

  def [](name)
    # dojo.languages['name']
    Language.new(self, name)
  end

end
