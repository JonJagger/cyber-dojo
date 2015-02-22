# comments at end of file

class Languages

  def path
    languages_path
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

  include ExternalDiskDir
  include ExternalLanguagesPath

  def latest(name)
    renames = {
      # from way back when test name was not part of language name
      'C'            => 'C-assert',
      'C++'          => 'C++-assert',
      'C#'           => 'C#-NUnit',
      'Clojure'      => 'Clojure-.test',
      'CoffeeScript' => 'CoffeeScript-jasmine',
      'Erlang'       => 'Erlang-eunit',
      'Go'           => 'Go-testing',
      'Haskell'      => 'Haskell-hunit',
      'Javascript'   => 'Javascript-assert',
      'Perl'         => 'Perl-TestSimple',
      'PHP'          => 'PHP-PHPUnit',
      'Python'       => 'Python-unittest',
      'Ruby'         => 'Ruby-TestUnit',
      'Scala'        => 'Scala-scalatest',
        
      # display name is different to folder name
      'C++-catch'                   => 'C++-Catch',
      'Javascript-Mocha+chai+sinon' => 'Javascript-mocha_chai_sinon',
      'Perl-Test::Simple'           => 'Perl-TestSimple',
      'Python-py.test'              => 'Python-pytest',
      'Ruby-RSpec'                  => 'Ruby-Rspec',
      'Ruby-Test::Unit'             => 'Ruby-TestUnit',

      # version numbers in language name?
      'Java'               => 'Java-1.8_JUnit',
      'Java-JUnit'         => 'Java-1.8_JUnit',
      'Java-JMock'         => 'Java-1.8_JMock',
      'Java-Approval'      => 'Java-1.8_Approval',
      'Java-ApprovalTests' => 'Java-1.8_Approval',
      'Java-Cucumber'      => 'Java-1.8_Cucumber',
      'Java-Mockito'       => 'Java-1.8_Mockito',
      'Java-JUnit-Mockito' => 'Java-1.8_Mockito',
      'Java-PowerMockito'  => 'Java-1.8_Powermockito'
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

# - - - - - - - - - - - - - - - - - - - - - - - -
# Some languages/ sub-folders have been renamed.
# This creates a problem for practice-sessions done
# before the rename that you now wish to review or
# fork from. Particularly for sessions with
# well known id's such as the refactoring dojos.
# For example...
# Suppose a old practice-session was done with a
# language name of 'Java' then in Kata.rb
# manifest['language'] will be 'Java'
# However kata.language  is defined as
#   dojo.languages[manifest['language']]
# And Languages' [] index operator (above)
# maps the incoming name to the latest name.
# Thus
#    old_name = kata.maninfest['language']
#    language = dojo.languages[old_name]
#    new_name = language.name
#    assert_sometimes old_name != new_name
# - - - - - - - - - - - - - - - - - - - - - - - -
