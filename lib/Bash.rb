
class Bash
  
  def exec(command)
    output = `#{command}`
    return output, $?.exitstatus    
  end
  
end
