
def avatar_image(one)
  yield image_tag "avatars/#{one.downcase}.jpg", 
   		:class => 'avatar box', 
   		:title => "#{one.humanize}"
end


