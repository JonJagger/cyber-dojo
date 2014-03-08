require File.dirname(__FILE__) + '/../test_helper'
require 'ExposedLinux/Paas'
require File.dirname(__FILE__) + '/../app_models/spy_disk'
require File.dirname(__FILE__) + '/../app_models/stub_git'
require File.dirname(__FILE__) + '/../app_models/stub_runner'

class LanguagesTests < ActionController::TestCase

  def setup
    @disk = SpyDisk.new
    @git = StubGit.new
    @runner = StubRunner.new
    @paas = ExposedLinux::Paas.new(@disk, @git, @runner)
    @format = 'rb'
    @dojo = @paas.create_dojo(root_path + '../../', @format)
  end

  def teardown
    @disk.teardown
  end

  test "dojo.languages.each() forwards to paas.languages_each()" do
    languages = @dojo.languages.map {|language| language.name}
    assert languages.include?('C#')
    assert languages.include?('Ruby')
  end

  test "dojo.languages[name] returns language with given name" do
    language = @dojo.languages["Ruby-Cucumber"]
    assert_equal ExposedLinux::Language, language.class
    assert_equal "Ruby-Cucumber", language.name
  end

  test "language.visible_files" do
    language = @dojo.languages["Ruby-Cucumber"]
    visible_filenames = [ 'wibble.rb', 'wibble_tests.rb' ]
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({
      'visible_filenames' => visible_filenames
    }))
    assert_equal visible_filenames, language.visible_filenames
  end

end
