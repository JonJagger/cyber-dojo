
# no isolation/protection/security, nothing.
# See DockerRunner.rb

class RawRunner
  include Runner

  def runnable?(language)
    true
  end

  def run(paas, sandbox, command, max_seconds)
    path = paas.path(sandbox)
    pipe_run("cd '#{path}';" + command, max_seconds)
  end

  def pipe_run(command, max_seconds)
    pipe = IO::popen(with_stderr(command))
    output = ""
    sandbox_thread = Thread.new { output += pipe.read }
    result = sandbox_thread.join(max_seconds);
    timed_out = (result == nil)

    if sandbox_thread != nil
      Thread.kill(sandbox_thread)
    end
    pid = pipe.pid
    kill(descendant_pids_of(pid))
    pipe.close
    if timed_out
      output += terminated(max_seconds)
    end
    output
  end

private

  def kill(pids)
    return if pids == [ ]
    `kill #{pids.join(' ')}`
  end

  def descendant_pids_of(base)
    # From http://t-a-w.blogspot.com/2010/04/how-to-kill-all-your-children.html
    # Autovivify the hash
    descendants = Hash.new { |ht,k| ht[k] = [k] }
    # Get process parentage information and turn it into a hash
    pid_map = Hash[*`ps -eo pid,ppid`.scan(/\d+/).map{ |x| x.to_i }]
    # For each process, add a reference to its descendants list
    # to its parent's descendants list
    pid_map.each{ |pid,ppid| descendants[ppid] << descendants[pid] }
    # Flatten away the generations
    descendants[base].flatten - [base]
  end

end