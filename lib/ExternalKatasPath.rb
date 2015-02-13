
module ExternalKatasPath # mixin

  def katas_path
    external(:katas_path)
  end

private

  include External

end
