require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasLanguageTests < LinuxPaasModelTestCase

  test "name is as set in ctor" do
    rb_and_json(&Proc.new{|format|
      language = @dojo.languages['Ruby']
      assert_equal 'Ruby', language.name
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is not in manifest then visible_files is empty hash" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal({ }, @language.visible_files)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is empty array in manifest then visible_files is empty hash" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ ] })
      assert_equal({ }, @language.visible_files)
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "when :visible_filenames is non-empty array in manifest then visible_files are loaded but not output and not instructions" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      @paas.dir(@language).spy_read('test_untitled.rb', 'content')
      visible_files = @language.visible_files
      assert_equal( { 'test_untitled.rb' => 'content' }, visible_files)
      assert_nil visible_files['output']
      assert_nil visible_files['instructions']
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "support_filenames defaults to [ ]" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      assert_equal [ ], @language.support_filenames
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "support_filenames set if not defaulted" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      support_filenames = [ 'x.jar', 'y.dll' ]
      spy_manifest({ 'support_filenames' => support_filenames })
      assert_equal support_filenames, @language.support_filenames
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "highlight_filenames defaults to [ ]" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      assert_equal [ ], @language.support_filenames
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "highlight_filenames set if not defaulted" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      visible_filenames = [ 'x.hpp', 'x.cpp' ]
      highlight_filenames = [ 'x.hpp' ]
      spy_manifest({
          'visible_filenames' => visible_filenames,
          'highlight_filenames' => highlight_filenames
        })
      assert_equal highlight_filenames, @language.highlight_filenames
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "unit_test_framework is set" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      unit_test_framework = 'Satchmo'
      spy_manifest({ 'unit_test_framework' => unit_test_framework })
      assert_equal unit_test_framework, @language.unit_test_framework
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab_size is set if not defaulted" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      tab_size = 42
      spy_manifest({ 'tab_size' => tab_size })
      assert_equal tab_size, @language.tab_size
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab_size defaults to 4" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      spy_manifest({ })
      assert_equal 4, @language.tab_size
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab is 7 spaces if tab_size is 7" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      tab_size = 7
      spy_manifest({ 'tab_size' => tab_size })
      assert_equal ' '*tab_size, @language.tab
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "tab defaults to 4 spaces" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      spy_manifest({ })
      assert_equal ' '*4, @language.tab
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "if manifest.rb and manifest.json exist, json is used" do
    rb_and_json(&Proc.new{|format|
      @language = @dojo.languages['Ruby']
      @paas.dir(@language).write('manifest.json', {'tab_size' => 4})
      @paas.dir(@language).write('manifest.rb', { :tab_size => 8 })
      @paas.dir(@language).spy_read('manifest.json', JSON.unparse({'tab_size' => 4}))
      assert_equal ' '*4, @language.tab
    })
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def spy_manifest(manifest)
    @paas.dir(@language).spy_read('manifest.json', JSON.unparse(manifest))
  end

end
