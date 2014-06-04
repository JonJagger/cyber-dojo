#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class LanguagesTests < ModelTestCase

  def stub_exists(languages_names)
    languages_names.each do |name|
      language = @dojo.languages[name]
      @paas.dir(language).spy_exists?('manifest.json')
    end
  end

  test "dojo.languages.each() empty" do
    stub_exists([ ])
    languages_names = @dojo.languages.map {|language| language.name}
    assert_equal [ ],languages_names
  end

  test "dojo.languages.each() forwards to paas.all_languages()" do
    expected = ['C#-NUnit','Ruby-TestUnit']
    stub_exists(expected)
    assert_equal @dojo.languages.map {|language| language.name}.sort, expected
  end

  test "dojo.languages[name] returns language with given name" do
    language = @dojo.languages["Ruby-Cucumber"]
    assert_equal Language, language.class
    assert_equal "Ruby-Cucumber", language.name
  end

end
