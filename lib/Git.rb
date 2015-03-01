
class Git

  def init(path, args)    
    cd_run(path, args)
  end

  def config(path, args)
    cd_run(path,args)
  end

  def add(path, args)
    cd_run(path,quoted(args))
  end

  def rm(path, args)
    cd_run(path,quoted(args))
  end

  def commit(path, args)
    cd_run(path,args)
  end

  def gc(path, args)
    cd_run(path,args)
  end

  def tag(path, args)
    cd_run(path,args)
  end

  def show(path, args)
    cd_run(path,args)
  end

  def diff(path, args)
    cd_run(path,args)
  end

private

  include Cleaner

  def cd_run(path, args)
    command = (caller[0] =~ /`([^']*)'/ and $1)
    Dir.chdir(path) do
       git_cmd = stderr2stdout("git #{command} #{args}")
       output = `#{git_cmd}` 
       status = $?.exitstatus
       if status != success
         log = [git_cmd+"\n", output, "$?.exitstatus=#{status}"]
         output = log.join('')
       end
       clean(output)       
    end    
  end
 
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
