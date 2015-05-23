
class Bash
  
  def exec(command)
    output = `#{command}`
    output, $?.exitstatus    
  end
  
end
