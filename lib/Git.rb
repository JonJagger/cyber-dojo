
class Git

  def method_missing(cmd,*args)
    path = args[0]
    options = args[1]
    options = quoted(options) if ['add','rm'].include?(cmd.to_s)
    Dir.chdir(path) do
      git_cmd = stderr2stdout("git #{cmd} #{options}")
      output = `#{git_cmd}` 
      status = $?.exitstatus
      if status != success
        log = [git_cmd + "\n", output, "$?.exitstatus=#{status}"]
        output = log.join('')
      end
      clean(output)       
    end        
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
