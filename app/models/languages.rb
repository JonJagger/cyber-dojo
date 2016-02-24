
class Languages
  include Enumerable

  def initialize(dojo)
    @parent = dojo
    @path = slashed(dojo.env('languages', 'root'))
  end

  # queries

  attr_reader :path, :parent

  def each(&block)
    languages.values.each(&block)
  end

  def [](name)
    languages[commad(name)] || languages[renamed(name)]
  end

  def write_cache
    cache = {}
    disk[path].each_dir do |dir_name|
      disk[path + dir_name].each_dir do |test_dir_name|
        next if test_dir_name == '_docker_context'
        language = make_language(dir_name, test_dir_name)
        cache[language.display_name] = {
               dir_name: dir_name,
          test_dir_name: test_dir_name,
             image_name: language.image_name
        }
      end
    end
    disk[path].write_json(cache_filename, cache)
  end

  def cache_filename
    'cache.json'
  end

  # modifiers

  private

  include ExternalParentChainer
  include LanguagesRename
  include Slashed

  def languages
    @languages ||= read_cache
  end

  def read_cache
    cache = {}
    disk[path].read_json(cache_filename).each do |display_name, language|
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

end
