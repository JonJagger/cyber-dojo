# comments at end of file

class Languages
  include ExternalParentChain
  
  def initialize(dojo,path)
    @parent,@path = dojo,path
  end
  
  attr_reader :path
  
  def each
    return enum_for(:each) unless block_given?
    languages.each { |language| yield language }
  end

  def [](name)
    language_name,testing_name = renamed(name)
    make_language(language_name,testing_name)
  end

  def renamed(was_name)
    loop do
      now_name = new_name(was_name).join('-')
      break if now_name === was_name
      was_name = now_name
    end
    was_name.split('-')
  end
  
private

  def new_name(name)    
    renames = {
      # from way back when test name was not part of language name
      'BCPL'         => 'BCPL-all_tests_passed',
      'C'            => 'C-assert',
      'C++'          => 'C++-assert',
      'C#'           => 'C#-NUnit',
      'Clojure'      => 'Clojure-.test',
      'CoffeeScript' => 'CoffeeScript-jasmine',
      'Erlang'       => 'Erlang-eunit',
      'Go'           => 'Go-testing',
      'Haskell'      => 'Haskell-hunit',
      'Java'         => 'Java-JUnit',      
      'Javascript'   => 'Javascript-assert',
      'Perl'         => 'Perl-TestSimple',
      'PHP'          => 'PHP-PHPUnit',
      'Python'       => 'Python-unittest',
      'Ruby'         => 'Ruby-TestUnit',
      'Scala'        => 'Scala-scalatest',

      # renamed
      'Java-ApprovalTests' => 'Java-Approval',
      'Java-JUnit-Mockito' => 'Java-Mockito',
      'Ruby-Test::Unit'    => 'Ruby-TestUnit',

      # display name is different to folder name
      'C++-catch'                   => 'C++-Catch',
      'Javascript-Mocha+chai+sinon' => 'Javascript-mocha_chai_sinon',
      'Perl-Test::Simple'           => 'Perl-TestSimple',
      'Python-py.test'              => 'Python-pytest',
      'Ruby-RSpec'                  => 'Ruby-Rspec',

      # - in the wrong place
      'Java-1.8_Approval'      => 'Java-Approval',
      'Java-1.8_Cucumber'      => 'Java-Cucumber',
      'Java-1.8_JMock'         => 'Java-JMock',
      'Java-1.8_JUnit'         => 'Java-JUnit',
      'Java-1.8_Mockito'       => 'Java-Mockito',
      'Java-1.8_Powermockito'  => 'Java-PowerMockito',

      # replaced
      'R-stopifnot' => 'R-RUnit',
      
      # multiple versions
      'C++-assert'     => 'g++4.8.1-assert',
      'C++-Boost.Test' => 'g++4.8.1-Boost.Test',
      'C++-Catch'      => 'g++4.8.1-Catch',
      'C++-CppUTest'   => 'g++4.8.1-CppUTest',
      'C++-GoogleTest' => 'g++4.8.1-GoogleTest',
      'C++-Igloo'      => 'g++4.8.1-Igloo',
      'C++-GoogleMock' => 'g++4.9-GoogleMock',
            
      'Ruby-Approval'      => 'Ruby1.9.3-Approval',
      'Ruby-Cucumber'      => 'Ruby1.9.3-Cucumber',
      'Ruby-TestUnit'      => 'Ruby1.9.3-TestUnit',
      'Ruby-Rspec'         => 'Ruby1.9.3-Rspec',
      'Ruby-MiniTest'      => 'Ruby2.1.3-MiniTest',            
    }
    (renames[name] || name).split('-')
  end

  def languages
    @languages ||= make_cache
  end

  def make_cache
    cache = [ ]
    dir.each_dir do |language_dir|
      disk[path + language_dir].each_dir do |test_dir|
        language = make_language(language_dir, test_dir)
        cache << language if language.exists? && language.runnable?
      end      
    end
    cache
  end

  def make_language(language_dir,test_dir)
    Language.new(self,language_dir,test_dir)
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - -
# Some languages/ sub-folders have been renamed.
# This creates a problem for practice-sessions done
# before the rename that you now wish to review or
# fork from. Particularly for sessions with
# well known id's such as the refactoring dojos.
# For example...
# Suppose an old practice-session was done with a
# language name of 'Java' then in Kata.rb
# manifest['language'] will be 'Java'
# However kata.language  is defined as
#   dojo.languages[manifest['language']]
# And Languages' [] index operator (above)
# maps the incoming name to the latest name.
# Thus
#    old_name = kata.manifest['language']
#    language = dojo.languages[old_name]
#    new_name = language.name
#    assert_sometimes old_name != new_name
# - - - - - - - - - - - - - - - - - - - - - - - -
