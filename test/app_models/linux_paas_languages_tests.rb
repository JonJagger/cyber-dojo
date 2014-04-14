require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasLanguagesTests < LinuxPaasModelTestCase

  test "dojo.languages.each() forwards to paas.languages_each()" do
    @paas.dir(@dojo.languages['C#'])
    @paas.dir(@dojo.languages['Ruby'])
    languages_names = @dojo.languages.map {|language| language.name}
    assert languages_names.include?('C#'), 'C#: ' + languages_names.inspect
    assert languages_names.include?('Ruby'), 'Ruby: ' + languages_names.inspect
  end

  test "dojo.languages[name] returns language with given name" do
    language = @dojo.languages["Ruby-Cucumber"]
    assert_equal Language, language.class
    assert_equal "Ruby-Cucumber", language.name
  end

  test "language.visible_files defaults to [ ]" do
    language = @dojo.languages["Ruby-Cucumber"]
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({}))
    assert_equal [ ], language.visible_filenames
  end

  test "language.visible_files when set from manifest" do
    language = @dojo.languages["Ruby-Cucumber"]
    visible_filenames = [ 'wibble.rb', 'wibble_tests.rb' ]
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({
      'visible_filenames' => visible_filenames
    }))
    assert_equal visible_filenames, language.visible_filenames
  end

  test "language.highlight_filenames defaults to [ ]" do
    language = @dojo.languages["Ruby-Cucumber"]
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({}))
    assert_equal [ ], language.highlight_filenames
  end

  test "language.highlight_filenames when set from manifest" do
    language = @dojo.languages["Ruby-Cucumber"]
    highlight_filenames = [ 'wibble.rb', 'wibble_tests.rb' ]
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({
      'highlight_filenames' => highlight_filenames
    }))
    assert_equal highlight_filenames, language.highlight_filenames
  end

  test "language tab defaults to 4 when not in manifest" do
    language = @dojo.languages["Ruby-Cucumber"]
    visible_filenames = [ 'wibble.rb', 'wibble_tests.rb' ]
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({}))
    assert_equal 4, language.tab_size
    assert_equal "    ", language.tab
  end

  test "language.tab when set from manifest" do
    language = @dojo.languages["Ruby-Cucumber"]
    visible_filenames = [ 'wibble.rb', 'wibble_tests.rb' ]
    @paas.dir(language).spy_read('manifest.json', JSON.unparse({
      'tab_size' => 5
    }))
    assert_equal 5, language.tab_size
    assert_equal "     ", language.tab
  end

end
