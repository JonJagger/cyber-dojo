
class Exercise
  
  def initialize(root_dir, name)
    @root_dir,@name = root_dir,name
  end
     
  def name
    @name
  end
  
  def instructions
    IO.read("#{exercise_dir}/instructions")
  end
          
private
  
  def exercise_dir
    @root_dir + '/exercises/' + name
  end
  
end
