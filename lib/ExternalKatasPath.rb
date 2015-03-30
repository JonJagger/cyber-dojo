
module ExternalKatasPath # mixin

  def katas_path?
    !ENV[katas_key].nil?
  end

  def katas_path
    path = ENV[katas_key]
    path += '/' if !path.end_with? '/'
    path
  end

  def set_katas_path(path)
    ENV[katas_key] = path
  end
  
private

  def katas_key
    'CYBER_DOJO_KATAS_ROOT'
  end

end
