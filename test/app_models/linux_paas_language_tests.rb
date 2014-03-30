require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasLanguageTests < LinuxPaasModelTestCase

  test "name is as set in ctor" do
    json_and_rb do
      language = @dojo.languages['Ruby']
      assert_equal 'Ruby', language.name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "exists? is false before dir is made" do
    json_and_rb do
      @language = @dojo.languages['Erlang']
      assert !@language.exists?
      @paas.dir(@language).make
      assert @language.exists?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is not in manifest then visible_files is empty hash" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal({}, @language.visible_files)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is empty array in manifest then visible_files is empty hash" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ ] })
      assert_equal({}, @language.visible_files)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is non-empty array in manifest then visible_files are loaded but not output and not instructions" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      @paas.dir(@language).spy_read('test_untitled.rb', 'content')
      visible_files = @language.visible_files
      assert_equal( { 'test_untitled.rb' => 'content' }, visible_files)
      assert_nil visible_files['output']
      assert_nil visible_files['instructions']
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "support_filenames defaults to [ ]" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      assert_equal [ ], @language.support_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "support_filenames set if not defaulted" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      support_filenames = [ 'x.jar', 'y.dll' ]
      spy_manifest({ 'support_filenames' => support_filenames })
      assert_equal support_filenames, @language.support_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "highlight_filenames defaults to [ ]" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      assert_equal [ ], @language.support_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "highlight_filenames set if not defaulted" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      visible_filenames = [ 'x.hpp', 'x.cpp' ]
      highlight_filenames = [ 'x.hpp' ]
      spy_manifest({
          'visible_filenames' => visible_filenames,
          'highlight_filenames' => highlight_filenames
        })
      assert_equal highlight_filenames, @language.highlight_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "display_name if set" do
    json_and_rb do
      name = 'Ruby-RSpec'
      @language = @dojo.languages[name]
      display_name = 'Ruby'
      spy_manifest({ 'display_name' => display_name })
      assert_equal name, @language.name
      assert_equal display_name, @language.display_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "display_name defaults to name" do
    json_and_rb do
      name = 'Ruby-Approval'
      @language = @dojo.languages[name]
      spy_manifest({ })
      assert_equal name, @language.name
      assert_equal name, @language.display_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "display_test_name if set" do
    json_and_rb do
      name = 'Java-Mockito'
      @language = @dojo.languages[name]
      expected = 'Mockito'
      spy_manifest({ 'display_test_name' => expected,
                     'unit_test_framework' => 'JUnit' })
      assert_equal expected, @language.display_test_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "display_test_name defaults to unit_test_framework" do
    json_and_rb do
      name = 'Java-Mockito'
      @language = @dojo.languages[name]
      expected = 'JUnit'
      spy_manifest({ 'unit_test_framework' => expected })
      assert_equal expected, @language.display_test_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "image_name if set" do
    json_and_rb do
      name = 'Ruby-Test::Unit'
      @language = @dojo.languages[name]
      expected = 'cyberdojo/language_ruby-1.9.3_test_unit'
      spy_manifest({ 'image_name' => expected })
      assert_equal expected, @language.image_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "image_name is nil if not set" do
    json_and_rb do
      name = 'Ruby-Test::Unit'
      @language = @dojo.languages[name]
      expected = nil
      spy_manifest({ })
      assert_equal expected, @language.image_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "unit_test_framework is set" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      unit_test_framework = 'Satchmo'
      spy_manifest({ 'unit_test_framework' => unit_test_framework })
      assert_equal unit_test_framework, @language.unit_test_framework
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab_size is set if not defaulted" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      tab_size = 42
      spy_manifest({ 'tab_size' => tab_size })
      assert_equal tab_size, @language.tab_size
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab_size defaults to 4" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal 4, @language.tab_size
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab is 7 spaces if tab_size is 7" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      tab_size = 7
      spy_manifest({ 'tab_size' => tab_size })
      assert_equal ' '*tab_size, @language.tab
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab defaults to 4 spaces" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal ' '*4, @language.tab
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if manifest.rb and manifest.json exist, json is used" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      @paas.dir(@language).write('manifest.json', {'tab_size' => 4})
      @paas.dir(@language).write('manifest.rb', {:tab_size => 8})
      @paas.dir(@language).spy_read('manifest.json', JSON.unparse({'tab_size' => 4}))
      assert_equal ' '*4, @language.tab
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def spy_manifest(manifest)
    @paas.dir(@language).spy_read('manifest.json', JSON.unparse(manifest))
  end

end
