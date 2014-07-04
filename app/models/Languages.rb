
class Languages
  
  include Enumerable

  def initialize(path,disk,runner)
    @path,@disk,@runner = path,disk,runner
  end

  attr_reader :path

  def each
    # dojo.languages.each {|language| ...}
    dir.each do |name|
      language = self[name]
      yield language if language.exists? && block_given?
    end
  end

  def [](name)
    # dojo.languages['name']
    Language.new(path,name,@disk,@runner)
  end

private

  def dir
    @disk[path]
  end

end
