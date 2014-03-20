require File.dirname(__FILE__) + '/linux_paas_model_test_case'

class LinxuPaasExerciseTests < LinuxPaasModelTestCase

  test "name is as set in ctor" do
    rb_and_json(&Proc.new{
      exercise = @dojo.exercises['Yahtzee']
      assert_equal 'Yahtzee', exercise.name
    })
  end

  test "instructions are loaded" do
    rb_and_json(&Proc.new{
      exercise = @dojo.exercises['Yahtzee']
      filename = 'instructions'
      content = 'fishing for Salmon on the Verdal'
      @paas.dir(exercise).spy_read(filename, content)
      assert_equal content, exercise.instructions
      assert @paas.dir(exercise).log.include?(['read',filename,content])
    })
  end

end
