
module LogoImageHelper
  
  def logo_image(size, title)
    image_tag "/images/avatars/cyber-dojo.png",
      :title => title,
      :width => size,
      :height => size
  end
  
end
