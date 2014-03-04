require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'

class LanguagesTests < ActionController::TestCase

  test "dojo.languages.each forwards to languages_each on paas" do
    paas = ExposedLinux::Paas.new
    dojo = paas.create_dojo(root_path,'rb')
    assert_equal ["Java","Ruby"], dojo.languages.map {|language| language.name}
  end

end
