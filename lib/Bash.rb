
class Bash
  
  def exec(command)
    output = `#{stderr2stdout(command)}`
    return output, $?.exitstatus    
  end
  
private

  include Stderr2Stdout
  
end
