
# > ruby test/functional/exercise_file_set_tests.rb

class ExerciseFileSet
  
  def initialize(dir)
    @dir = dir
  end
  
  def instructions
    IO.read(@dir + '/instructions')
  end

end
