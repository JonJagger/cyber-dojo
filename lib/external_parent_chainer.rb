
module ExternalParentChainer # mix-in

  def method_missing(command, *args)
    current = self
    loop { current = current.parent }
  rescue NoMethodError
    raise "not-expecting-arguments #{args}" if args != []
    current.send(command, *args)
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Provides transparent access to...
# 1. The external objects held in the root dojo object:
# See app/models/dojo.rb
#
#  runner   - performs the actual test run, using docker in some way.
#  katas    - access to cyber-dojo's sessions, by ID
#  shell    - executes shell commands, eg mkdir,ls,git
#  disk     - access to the file-system, directories, file read/write
#  log      - memory/stdout based logging.
#  git      - all required git commands. Forwards to shell.
#
# 2. The objects representing the main cyber-dojo folders:
#
# languages - as per setup page.
# exercises - as per setup page.
#
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Also allows the lib/ classes representing external objects to easily access
# each other by chaining back to the root dojo object. For example:
#
#     HostGit   -> shell -> dojo.shell -> HostShell
#     HostShell -> log   -> dojo.log   -> HostLog
#
# Works by assuming the object (which included this module) has a parent
# property and repeatedly chains back parent to parent to parent
# till it gets to an object without a parent property which it assumes
# is the root dojo object, which it delegates to.
