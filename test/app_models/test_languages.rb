#!/usr/bin/env ruby

require_relative 'model_test_base'

class LanguagesTests < ModelTestBase

  test 'path is set from :languages_path' do
    reset_external(:languages_path, 'end_with_slash/')
    assert_equal 'end_with_slash/', Languages.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path appends slash if necessary' do
    reset_external(:languages_path, 'languages')
    assert_equal 'languages/', Languages.new.path
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
    ['Ruby-Cucumber','C#-NUnit'].each do |name|
      assert_equal name, languages[name].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'name is translated when old language dir has been renamed' do
    renames = {
      'C'            => 'C-assert',
      'C++'          => 'C++-assert',
      'C#'           => 'C#-NUnit',
      'Clojure'      => 'Clojure-.test',
      'CoffeeScript' => 'CoffeeScript-jasmine',
      'Erlang'       => 'Erlang-eunit',
      'Go'           => 'Go-testing',
      'Haskell'      => 'Haskell-hunit',

      'C++-catch'                   => 'C++-Catch',
      'Javascript-Mocha+chai+sinon' => 'Javascript-mocha_chai_sinon',
      'Perl-Test::Simple'           => 'Perl-TestSimple',
      'Python-py.test'              => 'Python-pytest',
      'Ruby-RSpec'                  => 'Ruby-Rspec',
      'Ruby-Test::Unit'             => 'Ruby1.9.3-TestUnit',

      'Java'               => 'Java1.8-JUnit',
      'Java-JUnit'         => 'Java1.8-JUnit',
      'Java-Approval'      => 'Java1.8-Approval',
      'Java-ApprovalTests' => 'Java1.8-Approval',
      'Java-Cucumber'      => 'Java1.8-Cucumber',
      'Java-Mockito'       => 'Java1.8-Mockito',
      'Java-JUnit-Mockito' => 'Java1.8-Mockito',
      'Java-PowerMockito'  => 'Java1.8-Powermockito',

      'Javascript' => 'Javascript-assert',
      'Perl'       => 'Perl-TestSimple',
      'PHP'        => 'PHP-PHPUnit',
      'Python'     => 'Python-unittest',
      'Ruby'       => 'Ruby1.9.3-TestUnit',
      'Scala'      => 'Scala-scalatest'
    }
    renames.each do |was,now|
      assert_equal now, languages[was].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'name is recursively translated if multiple renames have occured' do
    assert_equal 'Ruby1.9.3-TestUnit', languages['Ruby'].name
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
