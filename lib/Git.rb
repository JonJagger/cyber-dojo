
class Git

  def method_missing(cmd,*args)
    path,options = args[0],args[1]
    options = quoted(options) if ['add','rm'].include?(cmd.to_s)
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

  include Cleaner

  def stderr2stdout(cmd)
    cmd + ' ' + '2>&1'
  end

  def success
    0
  end

  def quoted(args)
    "'" + args + "'"
  end

end
