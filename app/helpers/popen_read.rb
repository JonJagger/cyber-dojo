
# Originally I was writing
#   eval IO::popen(cmd).read
# However, running tests/functional/simulated_full_dojo_tests.rb
# and stopping it mid-run (^Z) and then issuing a 
#>ps 
# command showed many [sh <defunct>] processes.
# Googling, reveals that this means that the parent process
# had not yet wait()ed for it to finish.
# This popen call turned out to be he culprit.
# with this implementation, the above test passes.

def popen_read(cmd)  
  ios = IO::popen(with_stderr(cmd))
  begin
    output = ios.read
  ensure
    ios.close
  end
  output
end
  
def with_stderr(cmd)
  cmd + " " + "2>&1"
end

