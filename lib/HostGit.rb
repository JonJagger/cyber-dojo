
class HostGit

  def method_missing(cmd,*args)
    path,options = args[0],args[1]
    options = single_quoted(options) if ['add','rm'].include?(cmd.to_s)
    Dir.chdir(path) do
      git_cmd = stderr2stdout("git #{cmd} #{options}")
      log << git_cmd
      output = `#{git_cmd}` 
      log << output if output != ""
      status = $?.exitstatus
      log << "$?.exitstatus=#{status}" if status != success
      clean(output)       
    end        
  end

  def log
    @log ||= [ ]
  end
  
private

  include StringCleaner
  include Stderr2Stdout

  def success
    0
  end

  def single_quoted(s)
    "'" + s + "'"
  end
  
end
