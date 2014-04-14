require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasTests < LinuxPaasModelTestCase

  test "path(exercise)" do
    json_and_rb do
      exercise = @dojo.exercises['Yahtzee']
      assert @paas.path(exercise).match(exercise.name)
      assert path_ends_in_slash?(exercise)
      assert !path_has_adjacent_separators?(exercise)
      assert path_includes_dojo_path?(exercise)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(language)" do
    json_and_rb do
      language = @dojo.languages['Ruby']
      assert @paas.path(language).match(language.name)
      assert path_ends_in_slash?(language)
      assert !path_has_adjacent_separators?(language)
      assert path_includes_dojo_path?(language)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(kata)" do
    json_and_rb do
      id = '123456789A'
      kata = @dojo.katas[id]
      assert @paas.path(kata).include?(kata.id.inner)
      assert @paas.path(kata).include?(kata.id.outer)
      assert path_ends_in_slash?(kata)
      assert !path_has_adjacent_separators?(kata)
      assert path_includes_dojo_path?(kata)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "path(avatar) and path(sandbox)" do
    json_and_rb do |format|
      id = '123456789A'
      kata = @dojo.katas[id]

      language = @dojo.languages['C']
      language_manifest = {
        :unit_test_framework => 'assert'
      }
      @paas.dir(language).spy_read('manifest.json', JSON.unparse(language_manifest))

      kata_manifest = {
        :id => id,
        :visible_files => {
          'name' => 'content for name'
        },
        :language => language.name
      }
      if (format == 'rb')
        @paas.dir(kata).spy_read('manifest.rb', kata_manifest.inspect)
      end
      if (format == 'json')
        @paas.dir(kata).spy_read('manifest.json', JSON.unparse(kata_manifest))
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
      assert @paas.path(sandbox).include?('sandbox')
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "in RawRunner runnable? always returns true" do
    json_and_rb do |format|
      language = @dojo.languages['Java-JUnit']
      assert @paas.runnable?(language)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def path_ends_in_slash?(object)
    @paas.path(object).end_with?(@disk.dir_separator)
  end

  def path_has_adjacent_separators?(object)
    doubled_separator = @disk.dir_separator * 2
    @paas.path(object).scan(doubled_separator).length > 0
  end

  def path_includes_dojo_path?(object)
    @paas.path(object).include?(@dojo.path)
  end

end
