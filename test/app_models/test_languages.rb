#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class LanguagesTests < ModelTestCase

  test 'dojo.languages.each() empty' do
    stub_exists(expected = [ ])
    assert_equal expected, languages.map {|language| language.name}
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'dojo.languages.each() not empty' do
    stub_exists(expected = ['C#-NUnit','Ruby-TestUnit'])
    assert_equal expected, languages.map {|language| language.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'dojo.languages[name] returns language with given name' do
    ['Ruby-Cucumber','C#-NUnit'].each do |name|
      assert_equal name, languages[name].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  def languages
    @dojo.languages
  end

  def stub_exists(languages_names)
    languages_names.each do |name|
      language = languages[name]
      language.dir.spy_exists?(language.manifest_filename)
    end
  end

end
