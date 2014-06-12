#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class PaasTests < ModelTestCase

  test 'default format is json' do
    paas = Paas.new(nil,nil,nil)
    assert_equal 'json', paas.format
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'format can be set to rb' do
    paas = Paas.new(nil,nil,nil)
    paas.format_rb
    assert_equal 'rb', paas.format
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path(exercise)' do
    json_and_rb do
      exercise = @dojo.exercises['test_Yahtzee']
      assert exercise.path.match(exercise.name)
      assert path_ends_in_slash?(exercise)
      assert !path_has_adjacent_separators?(exercise)
      assert path_includes_dojo_path?(exercise)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path(language)' do
    json_and_rb do
      language = @dojo.languages['Ruby']
      assert language.path.match(language.name)
      assert path_ends_in_slash?(language)
      assert !path_has_adjacent_separators?(language)
      assert path_includes_dojo_path?(language)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path(kata)' do
    json_and_rb do
      kata = @dojo.katas[id]
      assert kata.path.include?(kata.id.inner)
      assert kata.path.include?(kata.id.outer)
      assert path_ends_in_slash?(kata)
      assert !path_has_adjacent_separators?(kata)
      assert path_includes_dojo_path?(kata)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'path(avatar) and path(sandbox)' do
    json_and_rb do |format|
      kata = @dojo.katas[id]

      language = @dojo.languages['test-C++-Catch']
      language_manifest = {
        :unit_test_framework => 'catch'
      }
      @paas.dir(language).spy_read('manifest.json', language_manifest)

      kata_manifest = {
        :id => id,
        :visible_files => {
          'name' => 'content for name'
        },
        :language => language.name
      }
      if (format == 'rb')
        @paas.dir(kata).spy_read('manifest.rb', kata_manifest)
      end
      if (format == 'json')
        @paas.dir(kata).spy_read('manifest.json', kata_manifest)
      end

      avatar = kata.start_avatar(Avatars.names)
      assert_equal 'alligator', avatar.name
      assert path_ends_in_slash?(avatar)
      assert !path_has_adjacent_separators?(avatar)
      assert path_includes_dojo_path?(avatar)

      sandbox = avatar.sandbox
      assert path_ends_in_slash?(sandbox)
      assert !path_has_adjacent_separators?(sandbox)
      assert path_includes_dojo_path?(avatar)
      assert sandbox.path.include?('sandbox')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  #test "in HostTestRunner runnable? returns false when language does not exist" do
  #  json_and_rb do |format|
  #    language = @dojo.languages['Java-JUnit']
  #    assert !@paas.runnable?(language)
  #  end
  #end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'in HostTestRunner runnable? always returns true' do
    json_and_rb do |format|
      language = @dojo.languages['test-Java-JUnit']
      assert @paas.runnable?(language)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def id
    '123456789A'
  end

  def path_ends_in_slash?(object)
    object.path.end_with?(@disk.dir_separator)
  end

  def path_has_adjacent_separators?(object)
    doubled_separator = @disk.dir_separator * 2
    object.path.scan(doubled_separator).length > 0
  end

  def path_includes_dojo_path?(object)
    object.path.include?(@dojo.path)
  end

end
