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
      @language = @dojo.languages['Java']
      support_filenames = [ 'x.jar', 'y.jar' ]
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
      @language = @dojo.languages['C']
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

  test "lowlight_filenames defaults to ['cyberdojo.sh','makefile'] if there is no entry for highlight_filenames" do
    json_and_rb do
      @language = @dojo.languages['C']
      visible_filenames = [ 'wibble.hpp', 'wibble.cpp' ]
      spy_manifest({
          'visible_filenames' => visible_filenames,
        })
      assert_equal ['cyber-dojo.sh','makefile'], @language.lowlight_filenames.sort
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "lowlight_filenames is visible_filenames - highlight_filenames if there is an entry for highlight_filenames" do
    json_and_rb do
      @language = @dojo.languages['C']
      visible_filenames = [ 'wibble.hpp', 'wibble.cpp', 'fubar.hpp', 'fubar.cpp' ]
      highlight_filenames = [ 'wibble.hpp', 'wibble.cpp' ]
      spy_manifest({
          'visible_filenames' => visible_filenames,
          'highlight_filenames' => highlight_filenames
        })
      assert_equal ['fubar.cpp','fubar.hpp'], @language.lowlight_filenames.sort
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

  test "image_name is empty string if not set" do
    json_and_rb do
      name = 'Ruby-Test::Unit'
      @language = @dojo.languages[name]
      expected = ""
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

  # test "if manifest.json does not exist..." do

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

  test "language can be asked if it is runnable" do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      assert @language.runnable?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "JSON.parse error raises exception naming the language" do
    json_and_rb do
      name = 'Ruby'
      @language = @dojo.languages[name]
      any_bad_json = "42"
      @paas.dir(@language).spy_read('manifest.json', any_bad_json)
      named = false
      begin
        @language.tab_size
      rescue Exception => ex
        named = ex.to_s.include?(name)
      end
      assert named
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  class CustomRunner
    def initialize(installed)
      @installed = installed
    end
    def runnable?(language)
      @installed.include?(language.name)
    end
  end

  test "custom runner that filters the language.runnable?" do
    @disk   = SpyDisk.new
    @git    = StubGit.new
    @runner = CustomRunner.new(['yes'])
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = 'json'
    @dojo = @paas.create_dojo(root_path, @format)
    assert @dojo.languages['yes'].runnable?
    assert !@dojo.languages['no'].runnable?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "DockerRunner.runnable?(language) is false if language does not have image_name set in manifest" do
    @disk   = SpyDisk.new
    @git    = StubGit.new
    @runner = DockerRunner.new
    @paas = LinuxPaas.new(@disk, @git, @runner)
    @format = 'json'
    @dojo = @paas.create_dojo(root_path, @format)
    ruby = @dojo.languages['Ruby']
    @paas.dir(ruby).write('manifest.json', { })
    assert !ruby.runnable?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def spy_manifest(manifest)
    @paas.dir(@language).spy_read('manifest.json', JSON.unparse(manifest))
  end

end
