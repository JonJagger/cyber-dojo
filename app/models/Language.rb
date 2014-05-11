
class Language

  def initialize(dojo, name)
    @dojo,@name = dojo,name
  end

  attr_reader :dojo, :name

  def exists?
    paas.exists?(self, manifest_filename)
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

  def new_name
    # Some languages/ sub-folders have been renamed.
    # This creates a problem for practice-sessions done
    # before the rename that you now wish to review or
    # fork from. Particularly for sessions with
    # well known id's such as the refactoring dojos.
    # See app/models/kata.rb language()

    case @name
    when 'C'                  then return 'C-assert'
    when 'C++'                then return 'C++-assert'
    when 'C#'                 then return 'C#-NUnit'
    when 'Clojure'            then return 'Clojure-.test'
    when 'CoffeeScript'       then return 'CoffeeScript-jasmine'
    when 'Erlang'             then return 'Erlang-eunit'
    when 'Go'                 then return 'Go-testing'
    when 'Haskell'            then return 'Haskell-hunit'

    when 'Java'               then return 'Java-1.8_JUnit'
    when 'Java-JUnit'         then return 'Java-1.8_JUnit'
    when 'Java-Approval'      then return 'Java-1.8_Approval'
    when 'Java-ApprovalTests' then return 'Java-1.8_Approval'
    when 'Java-Cucumber'      then return 'Java-1.8_Cucumber'
    when 'Java-Mockito'       then return 'Java-1.8_Mockito'
    when 'Java-JUnit-Mockito' then return 'Java-1.8_Mockito'
    when 'Java-PowerMockito'  then return 'Java-1.8_Powermockito'

    when 'Javascript'         then return 'Javascript-assert'
    when 'Perl'               then return 'Perl-TestSimple'
    when 'PHP'                then return 'PHP-PHPUnit'
    when 'Python'             then return 'Python-unittest'
    when 'Ruby'               then return 'Ruby-TestUnit'
    when 'Scala'              then return 'Scala-scalatest'
    else                           return @name
    end
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

end
