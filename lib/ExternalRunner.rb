
module ExternalRunner # mixin

  def runner
    external(:runner)
  end

private

  include External

end
