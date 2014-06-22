#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class LanguageTests < ModelTestCase

  test 'path(language)' do
    json_and_rb do
      language = @dojo.languages['Ruby']
      assert language.path.match(language.name)
      assert path_ends_in_slash?(language)
      assert !path_has_adjacent_separators?(language)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'filename_extension defaults to empty string when not set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal('', @language.filename_extension)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'filename_extension reads back as set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'filename_extension' => '.rb' })
      assert_equal('.rb', @language.filename_extension)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'new_name is translated when old language dir has been renamed' do
    json_and_rb do
      renames = {
        'C'            => 'C-assert',
        'C++'          => 'C++-assert',
        'C#'           => 'C#-NUnit',
        'Clojure'      => 'Clojure-.test',
        'CoffeeScript' => 'CoffeeScript-jasmine',
        'Erlang'       => 'Erlang-eunit',
        'Go'           => 'Go-testing',
        'Haskell'      => 'Haskell-hunit',

        'Java'               => 'Java-1.8_JUnit',
        'Java-JUnit'         => 'Java-1.8_JUnit',
        'Java-Approval'      => 'Java-1.8_Approval',
        'Java-ApprovalTests' => 'Java-1.8_Approval',
        'Java-Cucumber'      => 'Java-1.8_Cucumber',
        'Java-Mockito'       => 'Java-1.8_Mockito',
        'Java-JUnit-Mockito' => 'Java-1.8_Mockito',
        'Java-PowerMockito'  => 'Java-1.8_Powermockito',

        'Javascript' => 'Javascript-assert',
        'Perl'       => 'Perl-TestSimple',
        'PHP'        => 'PHP-PHPUnit',
        'Python'     => 'Python-unittest',
        'Ruby'       => 'Ruby-TestUnit',
        'Scala'      => 'Scala-scalatest'
      }
      renames.each do |was,now|
        assert_equal now, @dojo.languages[was].new_name
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'name is not translated when language dir has not been renamed' do
    json_and_rb do
      assert_equal 'Java-JUnit', @dojo.languages['Java-JUnit'].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'exists? is true only when dir and manifest exist' do
    json_and_rb do
      @language = @dojo.languages['Erlang']
      assert !@language.exists?, '1'
      @language.dir.make
      assert !@language.exists?, '2'
      spy_exists?(manifest_filename)
      assert @language.exists?, '3'
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when :visible_filenames is not in manifest ' +
       'then visible_files is empty hash ' +
       'and visible_filenames is empty array' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal({}, @language.visible_files)
      assert_equal([], @language.visible_filenames)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when :visible_filenames is empty array in manifest ' +
       'then visible_files is empty hash' +
       'and visible_filenames is empty array' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ ] })
      assert_equal({}, @language.visible_files)
      assert_equal([], @language.visible_filenames)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when :visible_filenames is non-empty array in manifest ' +
       'then visible_files are loaded but not output and not instructions' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      @language.dir.spy_read('test_untitled.rb', 'content')
      visible_files = @language.visible_files
      assert_equal( { 'test_untitled.rb' => 'content' }, visible_files)
      assert_nil visible_files['output']
      assert_nil visible_files['instructions']
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'support_filenames defaults to [ ] when not set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      assert_equal [ ], @language.support_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'support_filenames reads back as set' do
    json_and_rb do
      @language = @dojo.languages['Java']
      support_filenames = [ 'x.jar', 'y.jar' ]
      spy_manifest({ 'support_filenames' => support_filenames })
      assert_equal support_filenames, @language.support_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'highlight_filenames defaults to [ ] when not set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({ 'visible_filenames' => [ 'test_untitled.rb' ] })
      assert_equal [ ], @language.support_filenames
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'highlight_filenames reads back as set' do
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

  test "lowlight_filenames defaults to ['cyberdojo.sh','makefile','Makefile']" +
       "when there is no entry for highlight_filenames" do
    json_and_rb do
      @language = @dojo.languages['C']
      visible_filenames = [ 'wibble.hpp', 'wibble.cpp' ]
      spy_manifest({
          'visible_filenames' => visible_filenames,
        })
      expected = ['cyber-dojo.sh','makefile','Makefile'].sort
      assert_equal expected, @language.lowlight_filenames.sort
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'lowlight_filenames is visible_filenames - highlight_filenames ' +
       'when there is an entry for highlight_filenames' do
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

  test 'display_name reads back as set' do
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

  test 'display_name defaults to name when not set' do
    json_and_rb do
      name = 'Ruby-Approval'
      @language = @dojo.languages[name]
      spy_manifest({ })
      assert_equal name, @language.name
      assert_equal name, @language.display_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'display_test_name reads back as set' do
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

  test 'display_test_name defaults to unit_test_framework when not set' do
    json_and_rb do
      name = 'Java-Mockito'
      @language = @dojo.languages[name]
      expected = 'JUnit'
      spy_manifest({ 'unit_test_framework' => expected })
      assert_equal expected, @language.display_test_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'image_name is read back as set' do
    json_and_rb do
      name = 'Ruby-Test::Unit'
      @language = @dojo.languages[name]
      expected = 'cyberdojo/language_ruby-1.9.3_test_unit'
      spy_manifest({ 'image_name' => expected })
      assert_equal expected, @language.image_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'image_name is empty string when not set' do
    json_and_rb do
      name = 'Ruby-Test::Unit'
      @language = @dojo.languages[name]
      spy_manifest({ })
      assert_equal '', @language.image_name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'unit_test_framework is read back as set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      unit_test_framework = 'Satchmo'
      spy_manifest({ 'unit_test_framework' => unit_test_framework })
      assert_equal unit_test_framework, @language.unit_test_framework
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab_size is read back as set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      tab_size = 9
      spy_manifest({ 'tab_size' => tab_size })
      assert_equal tab_size, @language.tab_size
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab_size defaults to 4 when not set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal 4, @language.tab_size
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab is 7 spaces when tab_size is 7' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      tab_size = 7
      spy_manifest({ 'tab_size' => tab_size })
      assert_equal ' '*tab_size, @language.tab
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'tab defaults to 4 spaces when not set' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      spy_manifest({})
      assert_equal ' '*4, @language.tab
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  # test "when manifest.json does not exist..." do

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when manifest.rb and manifest.json exist, json is used' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      @language.dir.write('manifest.json', {'tab_size' => 4})
      @language.dir.write('manifest.rb', {:tab_size => 8})
      @language.dir.spy_read('manifest.json', {'tab_size' => 4})
      assert_equal ' '*4, @language.tab
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'language can be asked if it is runnable' do
    json_and_rb do
      @language = @dojo.languages['Ruby']
      assert @language.runnable?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'JSON.parse error raises exception naming the language' do
    json_and_rb do
      name = 'Ruby'
      @language = @dojo.languages[name]
      any_bad_json = '42'
      @language.dir.spy_read_raw('manifest.json', any_bad_json)
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

  test 'custom runner that filters the language.runnable?' do
    externals = {
      :disk => SpyDisk.new,
      :git => SpyGit.new,
      :runner => CustomRunner.new(['yes'])
    }
    @dojo = Dojo.new(root_path,'json',externals)
    assert @dojo.languages['yes'].runnable?
    assert !@dojo.languages['no'].runnable?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'DockerTestRunner.runnable?(language) is false ' +
       'when language does not have image_name set in manifest' do

    externals = {
      :disk => SpyDisk.new,
      :git => SpyGit.new,
      :runner => DockerTestRunner.new
    }
    @dojo = Dojo.new(root_path,'json',externals)
    ruby = @dojo.languages['Ruby']
    ruby.dir.write(manifest_filename, { })
    assert !ruby.runnable?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def spy_manifest(manifest)
    @language.dir.spy_read(manifest_filename, manifest)
  end

  def spy_exists?(filename)
    @language.dir.spy_exists?(filename)
  end

  def manifest_filename
    'manifest.json'
  end

end
