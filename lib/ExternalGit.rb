
module ExternalGit # mixin

  def git
    external(:git)
  end

private

  include External

end
