require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinuxPaasDojoTests < LinuxPaasModelTestCase

  test "path is as set in ctor" do
    json_and_rb do
      assert_equal root_path, @dojo.path
    end
  end

  test "languages['xxx'] gives you language which knows its name is 'xxx'" do
    json_and_rb do
      assert_equal 'xxx', @dojo.languages['xxx'].name
    end
  end

  test "exercises['yyy'] gives you exercise which knows its name is 'yyy'" do
    json_and_rb do
      assert_equal 'yyy', @dojo.exercises['yyy'].name
    end
  end

  test "c'tor format controls kata's manifest format" do
    json_and_rb do |fmt|
      language = @dojo.languages['Java-JUnit']
      @paas.dir(language).spy_read('manifest.json', JSON.unparse({
        :unit_test_framework => 'JUnit'
      }))
      exercise = @dojo.exercises['Yahtzee']
      @paas.dir(exercise).spy_read('instructions', 'your task...')
      kata = @dojo.make_kata(language, exercise)
      assert_equal 'manifest.'+fmt, kata.manifest_filename
      log = @paas.dir(kata).log
      assert filenames_written_to_in(log).include?('manifest.'+fmt)
    end
  end

end
