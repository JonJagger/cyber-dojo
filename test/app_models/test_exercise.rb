#!/usr/bin/env ruby

require File.dirname(__FILE__) + '/model_test_case'

class ExerciseTests < ModelTestCase

  test 'exists? is true only if dir and instructions exist' do
    json_and_rb do
      exercise = @dojo.exercises['test_Yahtzee']
      assert !exercise.exists?
      @paas.dir(exercise).make
      assert !exercise.exists?
      @paas.dir(exercise).spy_exists?('instructions')
      assert exercise.exists?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'name is as set in ctor' do
    json_and_rb do
      exercise = @dojo.exercises['test_Yahtzee']
      assert_equal 'test_Yahtzee', exercise.name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - -

  test 'instructions are loaded from file of same name' do
    json_and_rb do
      exercise = @dojo.exercises['test_Yahtzee']
      filename = 'instructions'
      content = 'The game of Yahtzee...'
      @paas.dir(exercise).spy_read(filename, content)
      assert_equal content, exercise.instructions
      assert @paas.dir(exercise).log.include?(['read',filename,content])
    end
  end

end
