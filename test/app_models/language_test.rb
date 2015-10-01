#!/bin/bash ../test_wrapper.sh

require_relative 'AppModelTestBase'
require 'tempfile'

class LanguageTests < AppModelTestBase

  def setup
    super
    set_languages_root(self.class.tmp_root + 'languages')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '43EACE',
  "language's path has correct format" do
    @language = make_language(language_dir = 'C#', test_dir = 'NUnit')
    assert @language.path.match(language_dir + '/' + test_dir)
    assert correct_path_format?(@language)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4A975D',
  'filename_extension defaults to empty string when not set' do
    @language = make_language('C#', 'NUnit')
    spy_manifest({})
    assert_equal('', @language.filename_extension)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '761534',
  'filename_extension reads back as set' do
    @language = make_language('C#', 'NUnit')
    spy_manifest({ 'filename_extension' => '.cs' })
    assert_equal('.cs', @language.filename_extension)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F273BE',
  'exists? is true only when dir exists' do
    @language = make_language('C#', 'NUnit')
    refute @language.exists?, '1'
    @language.dir.make
    assert @language.exists?, '2'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '3D9F75',
    'when :visible_filenames is not in manifest' +
       'then visible_files is empty hash ' +
       'and visible_filenames is empty array' do
    @language = make_language('C#', 'NUnit')
    spy_manifest({})
    assert_equal({}, @language.visible_files)
    assert_equal([], @language.visible_filenames)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'B426B4',
    'when :visible_filenames is empty array in manifest' +
       'then visible_files is empty hash' +
       'and visible_filenames is empty array' do
    @language = make_language('C#', 'NUnit')
    spy_manifest({ 'visible_filenames' => [] })
    assert_equal({}, @language.visible_files)
    assert_equal([], @language.visible_filenames)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'EA1DCE',
    'when :visible_filenames is non-empty array in manifest' +
       'then visible_files are loaded but not output and not instructions' do
    @language = make_language('C#', 'NUnit')
    filename = 'test_untitled.cs'
    spy_manifest({ 'visible_filenames' => [filename] })
    @language.dir.write(filename, 'content')
    visible_files = @language.visible_files
    assert_equal({ filename => 'content' }, visible_files)
    assert_nil visible_files['output']
    assert_nil visible_files['instructions']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A42D66',
  'highlight_filenames defaults to [] when not set' do
    @language = make_language('C#', 'NUnit')
    spy_manifest({ 'visible_filenames' => ['test_untitled.cs'] })
    assert_equal [], @language.highlight_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '861A75',
  'highlight_filenames reads back as set' do
    @language = make_language('C#', 'NUnit')
    visible_filenames = ['x.cs', 'y.cs']
    highlight_filenames = ['x.cs']
    spy_manifest({
        'visible_filenames' =>   visible_filenames,
      'highlight_filenames' => highlight_filenames
    })
    assert_equal highlight_filenames, @language.highlight_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '7E3D8B',
    "lowlight_filenames defaults to" +
       "['cyberdojo.sh','makefile','Makefile','unity.license.txt']" +
       "when there is no entry for highlight_filenames" do
    @language = make_language('C#', 'NUnit')
    visible_filenames = ['wibble.cs', 'fubar.cs']
    spy_manifest({ 'visible_filenames' => visible_filenames })
    expected = ['cyber-dojo.sh', 'makefile', 'Makefile', 'unity.license.txt'].sort
    assert_equal expected, @language.lowlight_filenames.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '829855',
    'lowlight_filenames is visible_filenames - highlight_filenames' +
       'when there is an entry for highlight_filenames' do
    @language = make_language('C++', 'assert')
    visible_filenames = ['wibble.hpp', 'wibble.cpp', 'fubar.hpp', 'fubar.cpp']
    highlight_filenames = ['wibble.hpp', 'wibble.cpp']
    spy_manifest({
        'visible_filenames' =>   visible_filenames,
      'highlight_filenames' => highlight_filenames
    })
    assert_equal ['fubar.cpp', 'fubar.hpp'], @language.lowlight_filenames.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'A74292',
  'display_name reads back as set when not renamed' do
            name = 'C (gcc)-assert'
    display_name = 'C (gcc), assert'
    @language = make_language('C', 'assert')
    spy_manifest({ 'display_name' => display_name })
    assert_equal name, @language.name
    assert_equal display_name, @language.display_name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '229DC5',
  'image_name is read back as set' do
    @language = make_language('Ruby', 'Test::Unit')
    expected = 'cyberdojofoundation/language_ruby-1.9.3_test_unit'
    spy_manifest({ 'image_name' => expected })
    assert_equal expected, @language.image_name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '56CB2A',
  'unit_test_framework is read back as set' do
    @language = make_language('Ruby', 'Test::Unit')
    unit_test_framework = 'Satchmo'
    spy_manifest({ 'unit_test_framework' => unit_test_framework })
    assert_equal unit_test_framework, @language.unit_test_framework
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '07290B',
  'tab_size is read back as set' do
    @language = make_language('Ruby', 'Test::Unit')
    tab_size = 9
    spy_manifest({ 'tab_size' => tab_size })
    assert_equal tab_size, @language.tab_size
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '60F690',
  'tab_size defaults to 4 when not set' do
    @language = make_language('Ruby', 'Test::Unit')
    spy_manifest({})
    assert_equal 4, @language.tab_size
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '7E38C3',
  'tab is 7 spaces when tab_size is 7' do
    @language = make_language('Ruby', 'Test::Unit')
    tab_size = 7
    spy_manifest({ 'tab_size' => tab_size })
    assert_equal ' ' * tab_size, @language.tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '227942',
  'tab defaults to 4 spaces when not set' do
    @language = make_language('Ruby', 'Test::Unit')
    spy_manifest({})
    assert_equal ' ' * 4, @language.tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'F9DC8D',
  'progress_regexs reads back as set' do
    @language = make_language('Ruby', 'Test::Unit')
    regexs = [
      "Errors \\((\\d)+ failures\\)",
      "OK \\((\\d)+ tests\\)"
    ]
    spy_manifest({
      'progress_regexs' => regexs
    })
    assert_equal regexs, @language.progress_regexs
    Regexp.new(regexs[0])
    Regexp.new(regexs[1])
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '5EE3B5',
  'progress_regexs defaults to empty array' do
    @language = make_language('Ruby', 'Test::Unit')
    spy_manifest({})
    assert_equal [], @language.progress_regexs
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '397AB2',
  'language.runnable? delegates to runner' do
    runner.stub_runnable(true)
    @language = make_language('Ruby', 'Test::Unit')
    assert @language.runnable?
    runner.stub_runnable(false)
    refute @language.runnable?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'CF389F',
  'bad JSON in manifest raises exception naming the language' do
    @language = make_language('Ruby', 'Test::Unit')
    @language.dir.make
    @language.dir.write(manifest_filename, any_bad_json = '42')
    message = ''
    begin
      @language.tab_size
    rescue StandardError => ex
      message = ex.message
    end
    assert message.include?('Ruby')
    assert message.include?('Test::Unit')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private

  def make_language(language_dir, test_dir)
    Language.new(languages, language_dir, test_dir)
  end

  def spy_manifest(manifest)
    @language.dir.make
    @language.dir.write_json(manifest_filename, manifest)
  end

  def manifest_filename
    'manifest.json'
  end

end
