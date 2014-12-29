
class Languages

  def initialize(path)
    raise_if_no([:disk])
    @path = path
  end

  attr_reader :path

  def each
    return enum_for(:each) unless block_given?
    languages.each do |language|
      yield language
    end
  end

  def [](name)
    make_language(name)
  end

private

  include Externals

  def languages
    @languages ||= make_cache
  end

  def make_cache
    cache = [ ]
    dir.each_dir do |sub_dir|
      language = make_language(sub_dir)
      cache << language if language.exists? && language.runnable?
    end
    cache
  end

  def make_language(name)
    Language.new(path,name)
  end

end
