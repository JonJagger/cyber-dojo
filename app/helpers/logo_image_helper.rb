
module LogoImageHelper
  
  def logo_image(size, title)
    image_tag "/images/avatars/cyber-dojo.png",
      :alt   => 'cyber-dojo yin-yang logo',
      :title => title,
      :width => size,
      :height => size
  end
  
end
