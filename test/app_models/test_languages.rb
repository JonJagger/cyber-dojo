#!/usr/bin/env ruby

require_relative 'model_test_base'

class LanguagesTests < ModelTestBase

  test 'path is set from :languages_path' do
    reset_external(:languages_path, 'end_with_slash/')
    assert_equal 'end_with_slash/', Languages.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'path appends slash if necessary' do
    reset_external(:languages_path, 'languages')
    assert_equal 'languages/', Languages.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'each() empty' do
    stub_exists(expected = [ ])
    assert_equal expected, languages.each.map {|language| language.name}
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'each() not empty' do
    stub_exists(expected = ['C#-NUnit','Ruby1.9.3-TestUnit'])
    assert_equal expected, languages.each.map {|language| language.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test '[name] returns language with given name' do
    ['C-assert','C#-NUnit'].each do |name|
      assert_equal name, languages[name].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'name is translated when old language dir has been renamed' do  
    renames =
    {
      'C#'                          => 'C#-NUnit',
      'C'                           => 'C-assert',      
      'Clojure'                     => 'Clojure-.test',
      'CoffeeScript'                => 'CoffeeScript-jasmine',
      'Erlang'                      => 'Erlang-eunit',
      'Go'                          => 'Go-testing',
      'Haskell'                     => 'Haskell-hunit',
      'Java'                        => 'Java-JUnit',      
      'Javascript'                  => 'Javascript-assert',
      'Javascript-Mocha+chai+sinon' => 'Javascript-mocha_chai_sinon',
      'Perl'                        => 'Perl-TestSimple',
      'PHP'                         => 'PHP-PHPUnit',
      'Python'                      => 'Python-unittest',
      'Python-py.test'              => 'Python-pytest',
      'Perl-Test::Simple'           => 'Perl-TestSimple',
      'Scala'                       => 'Scala-scalatest',

      'Java-ApprovalTests' => 'Java-Approval',
      'Java-JUnit-Mockito' => 'Java-Mockito',
      'Perl-Test::Simple'  => 'Perl-TestSimple',
      'Python-py.test'     => 'Python-pytest',
            
      'C++'            => 'g++4.8.1-assert',
      'C++-assert'     => 'g++4.8.1-assert',
      'C++-Catch'      => 'g++4.8.1-Catch',
      'C++-catch'      => 'g++4.8.1-Catch',
      'C++-Boost.Test' => 'g++4.8.1-Boost.Test', 
      'C++-CppUTest'   => 'g++4.8.1-CppUTest',
      'C++-GoogleTest' => 'g++4.8.1-GoogleTest',
      'C++-Igloo'      => 'g++4.8.1-Igloo',
      'C++-GoogleMock' => 'g++4.9-GoogleMock', 
      

      'Ruby'             => 'Ruby1.9.3-TestUnit',      
      'Ruby-Test::Unit'  => 'Ruby1.9.3-TestUnit',
      'Ruby-TestUnit'    => 'Ruby1.9.3-TestUnit',
      'Ruby-Approval'    => 'Ruby1.9.3-Approval',
      'Ruby-Cucumber'    => 'Ruby1.9.3-Cucumber',
      'Ruby-RSpec'       => 'Ruby1.9.3-Rspec',
      'Ruby-Rspec'       => 'Ruby1.9.3-Rspec',
      'Ruby-MiniTest'    => 'Ruby2.1.3-MiniTest'      
    }
  
    renames.each do |was,now|
      assert_equal now, languages[was].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'name is not translated when language dir has not been renamed' do
    assert_equal 'C#-NUnit', languages['C#-NUnit'].name
  end

  #- - - - - - - - - - - - - - - - - - - - -

  def languages
    @dojo.languages
  end

  def stub_exists(languages_names)    
    languages_names.each do |name|
      languages[name].dir.write('manifest.json', {})
    end
  end

end
