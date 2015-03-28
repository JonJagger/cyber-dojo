
module ExternalKatasPath # mixin

  def katas_path
    #external(:katas_path)
    ENV['CYBER_DOJO_KATAS_ROOT']    
  end

private

  #include External

end
