
class Languages

  def initialize
    @languages_path = languages_path
    @languages_path += '/' if !languages_path.end_with?('/')
  end

  def path
    @languages_path
  end

  def each
    return enum_for(:each) unless block_given?
    languages.each do |language|
      yield language
    end
  end

  def [](name)
    make_language(latest(name))
  end

private

  include ExternalGetter

  def latest(name)
    # Some languages/ sub-folders have been renamed.
    # This creates a problem for practice-sessions done
    # before the rename that you now wish to review or
    # fork from. Particularly for sessions with
    # well known id's such as the refactoring dojos.
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
