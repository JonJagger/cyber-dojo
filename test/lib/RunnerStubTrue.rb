
class RunnerStubTrue

  def runnable?(language)
    true
  end

  def run(sandbox, command, max_duration)
    if @output.nil?
      raise RuntimeError.new("RunnerStubTrue.run()) called unexpectedly")
    end
    @output
  end

  def started(avatar); end

end

# - - - - - - - - - - - - - - - - - - - - - - - - -
# In test/app_controllers/setup_test.rb I originally
# had a test that did this
# 
#       set_runner_class_name('RunnerStubTrue')
#       runner.stub_runnable(true)
#       ...
#       get 'setup/show', :id => id[0...n]
#
# This doesn't work. The problem is that once get
# is called there is a context/thread switch
# a *new* runner object is created.
# - - - - - - - - - - - - - - - - - - - - - - - - -
