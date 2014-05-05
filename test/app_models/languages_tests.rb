require File.dirname(__FILE__) + '/model_test_case'

class LanguagesTests < ModelTestCase

  def stub_exists(languages_names)
    languages_names.each do |name|
      language = @dojo.languages[name]
      @paas.dir(language).spy_read('manifest.json', JSON.unparse({}))
      language.tab # stop spy saying 'not read'
    end
  end

  test "dojo.languages.each() forwards to paas.languages_each()" do
    stub_exists(['C#-NUnit','Ruby-TestUnit'])
    languages_names = @dojo.languages.map {|language| language.name}
    assert languages_names.include?('C#-NUnit'), 'C#-NUnit: ' + languages_names.inspect
    assert languages_names.include?('Ruby-TestUnit'), 'Ruby-TestUnit: ' + languages_names.inspect
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
