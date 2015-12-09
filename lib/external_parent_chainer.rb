
module ExternalParentChainer # mix-in

  def method_missing(command, *args)
    current = self
    loop { current = current.parent }
  rescue NoMethodError
    raise "not-expecting-arguments #{args}" if args != []
    current.send(command, *args)
  end

end

# Used by the app/models/ and lib/ classes.
# In particular it allows the lib/ classes representing external
# objects to access each other by chaining back to the root Dojo
# object. For example:
#     HostGit   -> shell -> dojo.shell -> HostShell
#     HostShell -> log   -> dojo.log   -> HostLog
