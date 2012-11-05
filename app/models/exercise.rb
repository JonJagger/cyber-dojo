
class Exercise
  
  def initialize(root_dir, name)
    @root_dir = root_dir
    @name = name
  end
     
  def name
    @name
  end
  
  def instructions
    IO.read("#{dir}/instructions")
  end
          
  def dir
    @root_dir + '/exercises/' + name
  end
  
end
