
class Languages

  include Enumerable

  def initialize(path,disk,runner)
    @path,@disk,@runner = path,disk,runner
  end

  attr_reader :path

  def each
    # dojo.languages.each {|language| ...}
    cache.each do |language|
      yield language if block_given?
    end
  end

  def [](name)
    # dojo.languages['name']
    make_language(name)
  end

private

  def cache
    @cache ||= make_cache
  end

  def make_cache
    made = [ ]
    dir.each do |sub_dir|
      language = make_language(sub_dir)
      made << language if language.exists?
    end
    made
  end

  def make_language(name)
    Language.new(path,name,@disk,@runner)
  end

  def dir
    @disk[path]
  end

end
