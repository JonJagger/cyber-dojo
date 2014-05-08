
class Language

  def initialize(dojo, name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo

  def name
    # Some language folders have been renamed.
    # This creates a problem for practice-sessions done
    # before the language-folder rename that you now
    # wish to fork from. Particularly for sessions with
    # well known id's such as the refactoring dojos.
    # So patch to the language new-name.
    case @name
    when 'C'                  then return 'C-assert'
    when 'C++'                then return 'C++-assert'
    when 'C#'                 then return 'C#-NUnit'
    when 'Clojure'            then return 'Clojure-.test'
    when 'CoffeeScript'       then return 'CoffeeScript-jasmine'
    when 'Erlang'             then return 'Erlang-eunit'
    when 'Go'                 then return 'Go-testing'
    when 'Haskell'            then return 'Haskell-hunit'
    when 'Java'               then return 'Java-JUnit'
    when 'Java-JUnit-Mockito' then return 'Java-Mockito'
    when 'Javascript'         then return 'Javascript-assert'
    when 'Perl'               then return 'Perl-TestSimple'
    when 'PHP'                then return 'PHP-PHPUnit'
    when 'Python'             then return 'Python-unittest'
    when 'Ruby'               then return 'Ruby-TestUnit'
    else                           return @name
    end
  end

  def exists?
    paas.exists?(TrueNameAdapter.new(@dojo,@name), manifest_filename)
  end

  def runnable?
    paas.runnable?(self)
  end

  def display_name
    manifest['display_name'] || @name
  end

  def display_test_name
    manifest['display_test_name'] || unit_test_framework
  end

  def image_name
    manifest['image_name'] || ""
  end

  def filename_extension
    manifest['filename_extension'] || ""
  end

  def visible_files
    Hash[visible_filenames.collect{ |filename|
      [ filename, read(filename) ]
    }]
  end

  def support_filenames
    manifest['support_filenames'] || [ ]
  end

  def highlight_filenames
    manifest['highlight_filenames'] || [ ]
  end

  def lowlight_filenames
    # Catering for two uses
    # 1. carefully constructed set of start files (like James Grenning uses)
    #    with explicitly set highlight_filenames entry in manifest
    # 2. default set of files direct from languages/
    #    viz, no highlight_filenames entry in manifest
    if highlight_filenames.length > 0
      return visible_filenames - highlight_filenames
    else
      return ['cyber-dojo.sh', 'makefile', 'Makefile']
    end
  end

  def unit_test_framework
    manifest['unit_test_framework']
  end

  def tab
    " " * tab_size
  end

  def tab_size
    manifest['tab_size'] || 4
  end

  def visible_filenames
    manifest['visible_filenames'] || [ ]
  end

  def manifest
    begin
      @manifest ||= JSON.parse(read(manifest_filename))
    rescue
      raise "JSON.parse(#{manifest_filename}) exception from language:" + name
    end
  end

private

  def read(filename)
    raw = paas.read(self, filename)
    raw.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def paas
    dojo.paas
  end

  def manifest_filename
    'manifest.json'
  end

  class TrueNameAdapter < Language
    # bypass the name-patch so exists? works as required
    def initialize(dojo,name)
      @dojo,@name = dojo,name
    end
    attr_reader :dojo, :name
  end

end
