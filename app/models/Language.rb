root = '../..'
require_relative root + '/app/lib/Approval'
require_relative root + '/app/lib/Cleaner'
require_relative root + '/app/lib/OutputParser'
require 'json'

class Language

  def initialize(path,name,disk,runner)
    @path,@name,@disk,@runner = path,name,disk,runner
  end

  attr_reader :name

  def path
    @path + name + '/'
  end

  def dir
    @disk[path]
  end

  def exists?
     dir.exists?(manifest_filename)
  end

  def runnable?
    @runner.runnable?(self)
  end

  def display_name
    manifest['display_name'] || name
  end

  def display_test_name
    manifest['display_test_name'] || unit_test_framework
  end

  def image_name
    manifest['image_name'] || ''
  end

  def filename_extension
    manifest['filename_extension'] || ''
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
    # See app/models/Kata.rb language()
    # See app/models/Kata.rb original_language()
    renames = {
      'C'            => 'C-assert',
      'C++'          => 'C++-assert',
      'C#'           => 'C#-NUnit',
      'Clojure'      => 'Clojure-.test',
      'CoffeeScript' => 'CoffeeScript-jasmine',
      'Erlang'       => 'Erlang-eunit',
      'Go'           => 'Go-testing',
      'Haskell'      => 'Haskell-hunit',

      'Java'               => 'Java-1.8_JUnit',
      'Java-JUnit'         => 'Java-1.8_JUnit',
      'Java-Approval'      => 'Java-1.8_Approval',
      'Java-ApprovalTests' => 'Java-1.8_Approval',
      'Java-Cucumber'      => 'Java-1.8_Cucumber',
      'Java-Mockito'       => 'Java-1.8_Mockito',
      'Java-JUnit-Mockito' => 'Java-1.8_Mockito',
      'Java-PowerMockito'  => 'Java-1.8_Powermockito',

      'Javascript' => 'Javascript-assert',
      'Perl'       => 'Perl-TestSimple',
      'PHP'        => 'PHP-PHPUnit',
      'Python'     => 'Python-unittest',
      'Ruby'       => 'Ruby-TestUnit',
      'Scala'      => 'Scala-scalatest'
    }
    renames[name] || name
  end

  def progress_regexs
    manifest['progress_regexs'] || [ ]
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - -

  def colour(output)
    OutputParser.colour(unit_test_framework, output)
  end

  def after_test(sandbox, visible_files)
    if name.include?('Approval')
      Approval.add_created_txt_files(sandbox.path, visible_files)
      Approval.remove_deleted_txt_files(sandbox.path, visible_files)
    end
  end

private

  include Cleaner

  def manifest
    begin
      @manifest ||= JSON.parse(read(manifest_filename))
    rescue Exception => e
      raise "JSON.parse(#{manifest_filename}) exception from language:" + path
    end
  end

  def manifest_filename
    'manifest.json'
  end

  def read(filename)
    clean(dir.read(filename))
  end

end
