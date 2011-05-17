
def avatar_image(one, size)
  image_tag "avatars/#{one.downcase}.jpg", 
   		:title => "#{one.humanize}",
      :width => size,
      :height => size,
      :class => "avatar_image"      
end


