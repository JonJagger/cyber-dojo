module AvatarImageHelper
  
  def avatar_image(one, size)

    one = one.downcase
    if one == 'compass'
      ext = 'png'
    else
      ext = 'jpg'
    end

    image_tag "avatars/#{one}.#{ext}",
      :title => one.humanize,
      :width => size,
      :height => size,
      :class => "avatar_image"
  end

  def bw_avatar_image(name, size)
    name = name.downcase
    image_tag "avatars/bw/#{name}.jpg",
      :title => name.humanize,
      :width => size,
      :height => size,
      :class => "avatar_image"    
  end
  
end
