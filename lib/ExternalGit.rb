
module ExternalGit # mixin

  def git(*args)    
    @@g ||= Object.const_get(git_class_name).new    
    return @@g if args.length === 0
    command = args[0]
    options = args[1]
    @@g.send(command, path, options)
  end

  def git?
    !git_class_name.nil?
  end
  
  def git_class_name
    ENV[git_key]
  end
  
  def set_git_class_name(value)
    ENV[git_key] = value
  end

private

  def git_key
    'CYBER_DOJO_GIT_CLASS_NAME'
  end

end
