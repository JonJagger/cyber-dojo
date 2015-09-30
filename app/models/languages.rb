# See comments at end of file

class Languages
  include Enumerable

  def self.cache_filename
    'languages_cache.json'
  end

  def initialize(dojo, path)
    @parent = dojo
    @path = path
    @path += '/' unless @path.end_with? '/'
  end

  attr_reader :path

  def each
    return enum_for(:each) unless block_given?
    languages.each { |_,language| yield language }
  end

  def [](name)
    languages[renamed(name)]
  end

  def refresh_cache
    cache = {}
    dir.each_dir do |dir_name|
      disk[path + dir_name].each_dir do |test_dir_name|
        language = make_language(dir_name, test_dir_name)
        cache[language.display_name] = {
               dir_name: dir_name,
          test_dir_name: test_dir_name,
             image_name: language.image_name
        }
      end
    end
    write_json(self.class.cache_filename, cache)
  end

  def renamed(name)
    return LanguagesNames.new(languages).new_name(name)
  end

  private

  include ExternalParentChain

  def languages
    @languages ||= read_cache
  end

  def read_cache
    cache = {}
    read_json(self.class.cache_filename).each do |display_name, language|
           dir_name = language['dir_name']
      test_dir_name = language['test_dir_name']
         image_name = language['image_name']
      cache[display_name] = make_language(dir_name, test_dir_name, display_name, image_name)
    end
    cache
  end

  def make_language(dir_name, test_dir_name, display_name = nil, image_name = nil)
    Language.new(self, dir_name, test_dir_name, display_name, image_name)
  end

end
