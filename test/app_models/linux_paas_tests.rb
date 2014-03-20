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
      uuid = Uuid.new(id)
      assert @paas.path(kata).include?(uuid.inner)
      assert @paas.path(kata).include?(uuid.outer)
      assert path_ends_in_slash?(kata)
      assert !path_has_adjacent_separators?(kata)
      assert path_includes_dojo_path?(kata)
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test "path(avatar)" do
    json_and_rb do
      id = '123456789A'
      kata = @dojo.katas[id]
      avatar = kata.start_avatar(Avatars.names)
      assert_equal 'alligator', avatar.name
      assert path_ends_in_slash?(avatar)
      assert !path_has_adjacent_separators?(avatar)
      assert path_includes_dojo_path?(avatar)
    end
  end
=end

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
