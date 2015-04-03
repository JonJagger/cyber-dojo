
module ExternalParentChain # mixin

  def dir
    disk[path]
  end

  def method_missing(command,*args)   
    if command == :git && args[0].class == Symbol
      args.unshift(path)
    end    
    return @parent.send(command,*args) 
  end

end
