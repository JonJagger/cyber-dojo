
module ExternalGit # mixin

  def git(*args)
    g = external(:git)
    return g if args.length === 0
    command = args[0]
    options = args[1]
    g.send(command, path, options)
  end

private

  include External

end
