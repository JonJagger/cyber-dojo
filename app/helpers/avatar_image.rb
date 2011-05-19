
def avatar_image(one, size)
  
  one = one.downcase
  if one == 'server'
    ext = 'png'
  else
    ext = 'jpg'
  end
  
  image_tag "avatars/#{one}.#{ext}", 
   		:title => "#{one.humanize}",
      :width => size,
      :height => size,
      :class => "avatar_image"      
end


