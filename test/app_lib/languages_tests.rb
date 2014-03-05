require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'

class LanguagesTests < ActionController::TestCase

  def setup
    paas = ExposedLinux::Paas.new
    @dojo = paas.create_dojo(root_path + '../../','rb')
  end

  test "dojo.languages.each forwards to languages_each on paas" do
    languages = @dojo.languages.map {|language| language.name}
    assert languages.include?('C#')
    assert languages.include?('Ruby')
  end

  test "dojo.languages[name]" do
    language = @dojo.languages["Ruby-Cucumber"]
    assert_equal ExposedLinux::Language, language.class
    assert_equal "Ruby-Cucumber", language.name
  end

end
