#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'
require 'tempfile'

class LanguageTests < ModelTestBase

  test 'path(language) has correct format' do
    language_dir,test_dir = 'C#','NUnit'    
    language = languages[language_dir + '-' + test_dir]
    assert language.path.match(language_dir + '/' + test_dir)
    assert path_ends_in_slash?(language)
    assert path_has_no_adjacent_separators?(language)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'filename_extension defaults to empty string when not set' do
    @language = languages['Ruby']
    spy_manifest({})
    assert_equal('', @language.filename_extension)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'filename_extension reads back as set' do
    @language = languages['Ruby']
    spy_manifest({ 'filename_extension' => '.rb' })
    assert_equal('.rb', @language.filename_extension)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is true only when dir and manifest exist' do
    set_disk_class_name('DiskFake')
    @language = languages['Erlang']
    assert !@language.exists?, '1'
    @language.dir.make
    assert !@language.exists?, '2'
    spy_manifest({})
    assert @language.exists?, '3'
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when :visible_filenames is not in manifest ' +
       'then visible_files is empty hash ' +
       'and visible_filenames is empty array' do
    @language = languages['Ruby']
    spy_manifest({})
    assert_equal({}, @language.visible_files)
    assert_equal([], @language.visible_filenames)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when :visible_filenames is empty array in manifest ' +
       'then visible_files is empty hash' +
       'and visible_filenames is empty array' do
    @language = languages['Ruby']
    spy_manifest({ 'visible_filenames' => [ ] })
    assert_equal({}, @language.visible_files)
    assert_equal([], @language.visible_filenames)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when :visible_filenames is non-empty array in manifest ' +
       'then visible_files are loaded but not output and not instructions' do
    @language = languages['C']
    spy_manifest({ 'visible_filenames' => [ 'test_untitled.c' ] })
    @language.dir.write('test_untitled.c', 'content')
    visible_files = @language.visible_files
    assert_equal( { 'test_untitled.c' => 'content' }, visible_files)
    assert_nil visible_files['output']
    assert_nil visible_files['instructions']
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'support_filenames defaults to [ ] when not set' do
    @language = languages['Ruby']
    spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
    assert_equal [ ], @language.support_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'support_filenames reads back as set' do
    @language = languages['Java']
    support_filenames = [ 'x.jar', 'y.jar' ]
    spy_manifest({ 'support_filenames' => support_filenames })
    assert_equal support_filenames, @language.support_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'highlight_filenames defaults to [ ] when not set' do
    @language = languages['Ruby']
    spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
    assert_equal [ ], @language.support_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'highlight_filenames reads back as set' do
    @language = languages['C']
    visible_filenames = [ 'x.hpp', 'x.cpp' ]
    highlight_filenames = [ 'x.hpp' ]
    spy_manifest({
        'visible_filenames' => visible_filenames,
        'highlight_filenames' => highlight_filenames
      })
    assert_equal highlight_filenames, @language.highlight_filenames
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "lowlight_filenames defaults to " +
       "['cyberdojo.sh','makefile','Makefile','unity.license.txt']" +
       "when there is no entry for highlight_filenames" do
    @language = languages['C']
    visible_filenames = [ 'wibble.hpp', 'wibble.cpp' ]
    spy_manifest({
        'visible_filenames' => visible_filenames,
      })
    expected = ['cyber-dojo.sh','makefile','Makefile','unity.license.txt'].sort
    assert_equal expected, @language.lowlight_filenames.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'lowlight_filenames is visible_filenames - highlight_filenames ' +
       'when there is an entry for highlight_filenames' do
    @language = languages['C']
    visible_filenames = [ 'wibble.hpp', 'wibble.cpp', 'fubar.hpp', 'fubar.cpp' ]
    highlight_filenames = [ 'wibble.hpp', 'wibble.cpp' ]
    spy_manifest({
        'visible_filenames' => visible_filenames,
        'highlight_filenames' => highlight_filenames
      })
    assert_equal ['fubar.cpp','fubar.hpp'], @language.lowlight_filenames.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'display_name reads back as set when not renamed' do
    name = 'C-assert'
    @language = languages[name]
    display_name = 'C, assert'
    spy_manifest({ 'display_name' => display_name })
    assert_equal name, @language.name
    assert_equal display_name, @language.display_name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'display_test_name reads back as set' do
    name = 'Java-Mockito'
    @language = languages[name]
    expected = 'Mockito'
    spy_manifest({ 'display_test_name' => expected,
                   'unit_test_framework' => 'JUnit' })
    assert_equal expected, @language.display_test_name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'display_test_name defaults to unit_test_framework when not set' do
    name = 'Java-Mockito'
    @language = languages[name]
    expected = 'JUnit'
    spy_manifest({ 'unit_test_framework' => expected })
    assert_equal expected, @language.display_test_name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'image_name is read back as set' do
    name = 'Ruby-Test::Unit'
    @language = languages[name]
    expected = 'cyberdojo/language_ruby-1.9.3_test_unit'
    spy_manifest({ 'image_name' => expected })
    assert_equal expected, @language.image_name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'unit_test_framework is read back as set' do
    @language = languages['Ruby']
    unit_test_framework = 'Satchmo'
    spy_manifest({ 'unit_test_framework' => unit_test_framework })
    assert_equal unit_test_framework, @language.unit_test_framework
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab_size is read back as set' do
    @language = languages['Ruby']
    tab_size = 9
    spy_manifest({ 'tab_size' => tab_size })
    assert_equal tab_size, @language.tab_size
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab_size defaults to 4 when not set' do
    @language = languages['Ruby']
    spy_manifest({})
    assert_equal 4, @language.tab_size
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab is 7 spaces when tab_size is 7' do
    @language = languages['Ruby']
    tab_size = 7
    spy_manifest({ 'tab_size' => tab_size })
    assert_equal ' '*tab_size, @language.tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab defaults to 4 spaces when not set' do
    @language = languages['Ruby']
    spy_manifest({})
    assert_equal ' '*4, @language.tab
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'progress_regexs reads back as set' do
    @language = languages['Ruby']
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

  test 'progress_regexs defaults to empty array' do
    @language = languages['Ruby']
    spy_manifest({})
    assert_equal [], @language.progress_regexs
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'language can be asked if it is runnable' do
    runner.stub_runnable(true)
    assert languages['Ruby'].runnable?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'JSON.parse error raises exception naming the language' do
    name = 'Ruby'
    @language = languages[name]
    any_bad_json = '42'
    @language.dir.write_raw('manifest.json', any_bad_json)
    named = false
    begin
      @language.tab_size
    rescue Exception => ex
      named = ex.to_s.include?(name)
    end
    assert named
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'RunnerStub.runnable?(language) is false ' +
       'when language does not have image_name set in manifest' do
    runner.stub_runnable(false)
    ruby = languages['Ruby-TestUnit']
    ruby.dir.write(manifest_filename, { }) # this line has no effect
    assert !ruby.runnable?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def spy_manifest(manifest)
    @language.dir.write(manifest_filename, manifest)
  end

  def manifest_filename
    'manifest.json'
  end

end
