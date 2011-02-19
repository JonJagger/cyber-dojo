
def avatar_image(one, size)
  image_tag "avatars/#{one.downcase}.jpg", 
   		:title => "#{one.humanize}",
      :width => size,
      :height => size
end

def reenter_button(dojo_name, avatar_name)
  "<form action='/kata/edit'>" +
    "<input type='hidden' name='dojo' id='dojo' value='#{dojo_name}'/>" +
    "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +
    "<input id='reenter_button'" + 
            "type='submit'" +
            "value='ReEnter'" + 
            "name='reenter' />" +
  "</form>"
end

def view_button(dojo_name, avatar_name)
  "<form action='/kata/view'>" +
    "<input type='hidden' name='dojo' id='dojo' value='#{dojo_name}'/>" +
    "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +
    "<input id='view_button'" + 
            "type='submit'" +
            "value='View'" + 
            "name='view' />" +
  "</form>"
end


