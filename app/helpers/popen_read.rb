
# Originally I was writing
#   eval IO::popen(cmd).read
# However, running tests/functional/simulated_full_dojo_tests.rb
# and stopping it mid-run (^Z) and then issuing a 
#>ps 
# command showed many [sh <defunct>] processes.
# Googling, reveals that this means that the parent process
# had not yet wait()ed for it to finish.
# The popen call turned out to be he culprit.
#
# Furthermore, the run_tests_timeout_tests.rb showed that
# if there was an infinite loop somewhere then the child
# processes of cyberdojo.sh were not being killed.
# What has to be done is ensure that _all_ the child processes, at
# whatever depth of parentage, are killed.  

def popen_read(cmd)
  output = ''  
  pipe = IO::popen(with_stderr(cmd))
  begin
    output = pipe.read
  ensure
    pids = descendant_pids_of(pipe.pid)
    pids.sort.reverse.each { |pid|
      Process.kill('HUP', pid)
      Process.wait
    }
  end
  output
end
  
def with_stderr(cmd)
  cmd + " " + "2>&1"
end


# From http://t-a-w.blogspot.com/2010/04/how-to-kill-all-your-children.html

def descendant_pids_of(base)
  descendants = Hash.new { |ht,k| ht[k] = [k] }
  # Get process parentage information and turn it into a hash  
  pid_map = Hash[*`ps -eo pid,ppid`.scan(/\d+/).map{ |x| x.to_i }]
  # For each process, add a reference to its descendants list 
  # to its parent's descendants list    
  pid_map.each{ |pid,ppid| descendants[ppid] << descendants[pid] }
  # Flatten away the generations 
  descendants[base].flatten
end

