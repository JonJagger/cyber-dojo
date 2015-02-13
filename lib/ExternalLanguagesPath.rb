
module ExternalLanguagesPath # mixin

  def languages_path
    external(:languages_path)
  end

private

  include External

end
