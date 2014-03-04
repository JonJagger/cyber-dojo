require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'

class LanguagesTests < ActionController::TestCase

  test "dojo.languages.each forwards to languages_each on paas" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    languages = dojo.languages.map {|language| language.name}
    assert languages.include?('C#')
    assert languages.include?('Ruby-installed-and-working')
  end

  test "dojo.languages[name]" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    language = dojo.languages["Ruby-Cucumber"]
    assert_equal ExposedLinux::Language, language.class
    assert_equal "Ruby-Cucumber", language.name
  end

end
