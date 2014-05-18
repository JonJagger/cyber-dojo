require File.dirname(__FILE__) + '/model_test_case'

class ExerciseTests < ModelTestCase

  test "exists? is true only if dir and instructions exist" do
    json_and_rb do
      exercise = @dojo.exercises['Salmo']
      assert !exercise.exists?
      @paas.dir(exercise).make
      assert !exercise.exists?
      filename = 'instructions'
      content = 'fishing for Salmon on the Verdal'
      @paas.dir(exercise).spy_read(filename,content)
      assert exercise.exists?
      # force spy to read instructions
      exercise.instructions
    end
  end

  test "name is as set in ctor" do
    json_and_rb do
      exercise = @dojo.exercises['test_Yahtzee']
      assert_equal 'test_Yahtzee', exercise.name
    end
  end

  test "instructions are loaded" do
    json_and_rb do
      exercise = @dojo.exercises['test_Yahtzee']
      filename = 'instructions'
      content = 'fishing for Salmon on the Verdal'
      @paas.dir(exercise).spy_read(filename, content)
      assert_equal content, exercise.instructions
      assert @paas.dir(exercise).log.include?(['read',filename,content])
    end
  end

end
