
module ExternalParentChain # mixin

  def dir
    disk[path]
  end

  def method_missing(command,*args)    
    @parent.send(command.to_s)
  end

end