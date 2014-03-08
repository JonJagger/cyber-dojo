require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../app_models/spy_disk'

class LanguagesTests < ActionController::TestCase

  def setup
    @disk = SpyDisk.new
    paas = ExposedLinux::Paas.new(@disk)
    @dojo = paas.create_dojo(root_path + '../../','rb')
  end

  def teardown
    @disk.teardown
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

  test "language.visible_files" do
    language = @dojo.languages["Ruby-Cucumber"]
    visible_filenames = [ 'wibble.h', 'wibble.c' ]
    @disk[language.path].spy_read('manifest.json', JSON.unparse({
      'visible_filenames' => visible_filenames
    }))
    assert_equal visible_filenames, language.visible_filenames
  end

end
