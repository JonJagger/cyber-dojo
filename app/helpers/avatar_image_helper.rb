
module AvatarImageHelper
  
  def avatar_image(name, size, title = name.downcase)
    name = name.downcase
    image_tag "/images/avatars/#{name}.jpg",
      :title => title,
      :width => size,
      :height => size,
      :class => "avatar_image"
  end
  
end
