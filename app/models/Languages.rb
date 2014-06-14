require 'Externals'

# dojo.languages['name']
# dojo.languages.each {|language| ...}

class Languages
  include Enumerable
  include Externals

  def initialize(dojo)
    @dojo = dojo
  end

  def path
    @dojo.path + 'languages/'
  end

  def each
    dir.each do |name|
      language = self[name]
      yield language if language.exists? && block_given?
    end
  end

  def [](name)
    Language.new(self,name)
  end

end
