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
    stub_exists(expected = ['C#-NUnit','Ruby-TestUnit'])
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
    renames.each do |was,now|
      assert_equal now, languages[was].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'name is not translated when language dir has not been renamed' do
    assert_equal 'Ruby-TestUnit', languages['Ruby-TestUnit'].name
  end

  #- - - - - - - - - - - - - - - - - - - - -

  def languages
    @dojo.languages
  end

  def stub_exists(languages_names)
    languages_names.each do |name|
      language = languages[name]
      language.dir.write('manifest.json', {})
    end
  end

end
