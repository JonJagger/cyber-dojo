
module ExternalLanguagesPath # mixin

  def languages_path
    #external(:languages_path)
    ENV['CYBER_DOJO_LANGUAGES_ROOT']
  end

private

  #include External

end
