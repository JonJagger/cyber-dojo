
module ExternalGit # mixin

  def git(*args)
    g = external(:git)
    return g if args.length === 0
    g.send(args[0], path, args[1])
  end

private

  include External

end
