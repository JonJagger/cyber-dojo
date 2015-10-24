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

  def each(&block)
    languages.values.each(&block)
  end

  def [](name)
    languages[commad(name)] || languages[renamed(name)]
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
    caches.write_json(self.class.cache_filename, cache)
  end

  private

  include ExternalParentChain
  include LanguagesRename

  def languages
    @languages ||= read_cache
  end

  def read_cache
    cache = {}
    caches.read_json(self.class.cache_filename).each do |display_name, language|
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

  def commad(name)
    name.split('-').join(', ')
  end

  def caches
    @parent.caches
  end

end
