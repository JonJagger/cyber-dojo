require File.dirname(__FILE__) + '/model_test_case'

class ExerciseTests < ModelTestCase

  test "name is as set in ctor" do
    json_and_rb do
      exercise = @dojo.exercises['Yahtzee']
      assert_equal 'Yahtzee', exercise.name
    end
  end

  test "instructions are loaded" do
    json_and_rb do
      exercise = @dojo.exercises['Yahtzee']
      filename = 'instructions'
      content = 'fishing for Salmon on the Verdal'
      @paas.dir(exercise).spy_read(filename, content)
      assert_equal content, exercise.instructions
      assert @paas.dir(exercise).log.include?(['read',filename,content])
    end
  end

end
