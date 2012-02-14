
# > ruby test/functional/exercise_file_set_tests.rb

class ExerciseFileSet
  
  def initialize(dir, exercise)
    @exercise = exercise
    @dir = dir + '/exercise/' + exercise
  end
  
  def instructions
    IO.read(@dir + '/instructions')
  end

  def exercise
    @exercise
  end
  
end
