
module ExternalLanguagesPath # mixin

  def languages_path?
    !ENV[languages_key].nil?
  end
  
  def languages_path
    path = ENV[languages_key]
    path += '/' if !path.end_with? '/'
    path
  end

  def set_languages_path(path)
    ENV[languages_key] = path
  end

private

  def languages_key
    'CYBER_DOJO_LANGUAGES_ROOT'
  end

end
